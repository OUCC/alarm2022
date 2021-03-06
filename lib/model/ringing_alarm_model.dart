import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'startup_process_model.dart';

/// RingingAlarm の初期化をする。mainで呼ぶ。
void setupRingingAlarm() {
  _setupTimeZone();
}

// タイムゾーンを設定する
Future<void> _setupTimeZone() async {
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);
}

///ミリ秒まで表示するフォーマッター
///- 返り値は hh:mm:ss.x の形の String
String formatTime(DateTime dt) {
  return "${DateFormat.Hms().format(dt)}.${dt.millisecond.toString().padRight(2, '0').substring(0, 1)}";
}

///アラームの管理をするクラス
class RingingAlarm {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer; // タイマーオブジェクト
  DateTime _time = DateTime.utc(0, 0, 0)
      .add(const Duration(seconds: 10)); // タイマーで管理している時間。10秒をカウントダウンする設定
  bool _isTimerActive = false; // バックグラウンドに遷移した際にタイマーが起動中かどうか
  DateTime? _pausedTime; // バックグラウンドに遷移した時間
  int? _notificationId; // 通知ID
  bool _notificationOnceFlag = false; //連続して通知ができないようにするフラグ

  DateTime get displayTime => _time;
  bool get isTimerActive => _isTimerActive;

  ///コンストラクタ
  RingingAlarm();

  /// アプリがバックグラウンドに遷移した際のハンドラ
  void handleOnPaused() {
    if (_timer != null && _timer!.isActive) {
      _isTimerActive = true;
      _timer!.cancel(); // タイマーを停止する
    }
    _pausedTime = DateTime.now(); // バックグラウンドに遷移した時間を記録
    if (_isTimerActive) {
      if (_notificationOnceFlag) {
        _notificationOnceFlag = false;
        if (_time
                .difference(DateTime.utc(0, 0, 0))
                .compareTo(const Duration(seconds: 1)) >
            0) {
          //タイマーの停止直後に再度通知を作りたがるので間隔を制限
          _notificationId = _scheduleLocalNotification(
              _time.difference(DateTime.utc(0, 0, 0))); // ローカル通知をスケジュール登録
        }
      }
    }
  }

  // フォアグラウンドに復帰した時のハンドラ
  void handleOnResumed() {
    if (_isTimerActive == false) return; // タイマーが動いてなければ何もしない
    Duration backgroundDuration =
        DateTime.now().difference(_pausedTime!); // バックグラウンドでの経過時間
    // バックグラウンドでの経過時間が終了予定を超えていた場合（この場合は通知実行済みのはず）
    if (_time.difference(DateTime.utc(0, 0, 0)).compareTo(backgroundDuration) <
        0) {
      _time = DateTime.utc(0, 0, 0); // 時間をリセットする
    } else {
      _time = _time.add(-backgroundDuration); // バックグラウンド経過時間分時間を進める
      startTimer(); // タイマーを再開する
    }
  }

  //予約済みの通知のリストを取得
  Future<List<PendingNotificationRequest>?> getPendingNotifications() async {
    List<PendingNotificationRequest>? list;
    list = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list;
  }

//予約の一覧表示
  void printPendingNotificationRequests() async {
    List<PendingNotificationRequest>? list = await getPendingNotifications();
    if (list == null) {
      debugPrint("PNR null");
      return;
    }
    if (list.isEmpty) {
      debugPrint("■■■ list is emply");
      return;
    }
    String string = "";
    for (int i = 0; i < list.length; i++) {
      debugPrint("■■■ list[$i] title : ${list[i].title}");
      debugPrint("■■■ list[$i]  id   : ${list[i].id}");
      debugPrint("■■■ list[$i] body  : ${list[i].body}");
      string += "id[$i]:${list[i].id}   ";
    }
    notice(string);
  }

//全予約キャンセル
  void cancelAllNotifications() async {
    List<PendingNotificationRequest>? list = await getPendingNotifications();
    if (list == null) return;
    //flutterLocalNotificationsPlugin.cancelAll();
    //return;
    for (int i = 0; i < list.length; i++) {
      cancelNotification(list[i].id);
    }
  }

  //鳴っている通知を消す(正確には最新の通知)//デバッグ用
  void resetNotification() {
    if (_notificationId != null) {
      flutterLocalNotificationsPlugin.cancel(_notificationId!); // 通知をキャンセル
    }
    _isTimerActive = false; // リセット
    _notificationId = null; // リセット
    _pausedTime = null;
    _notificationOnceFlag = false;
  }

  //指定のidの通知を消す
  void cancelNotification(int? nId) {
    if (nId != null) {
      flutterLocalNotificationsPlugin.cancel(nId); // 通知をキャンセル
      debugPrint("■■■ cancel id : $nId");
    }
    /*
    _isTimerActive = false; // リセット
    nId = null; // リセット
    _pausedTime = null;
    _notificationOnceFlag = false;
    */
  }

  // タイマーを開始する
  void startTimer() {
    if (_isTimerActive) return;
    _isTimerActive = true;
    _notificationOnceFlag = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      _time = _time.add(const Duration(milliseconds: -100));
      _handleTimeIsOver();
    }); // 1秒ずつ時間を減らす
  }

  // タイマーを初期化してから開始する
  void restartTimer() {
    if (_timer != null) _timer!.cancel();
    _time = DateTime.utc(0, 0, 0);
    _time = _time.add(const Duration(seconds: 10));
    startTimer();
  }

  // 時間がゼロになったらタイマーを止める
  void _handleTimeIsOver() {
    if (_timer != null &&
        _timer!.isActive &&
        //_time != null &&
        _time == DateTime.utc(0, 0, 0)) {
      _timer!.cancel();
      _notificationOnceFlag = false;
    }
  }

  //タイマーを止める
  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isTimerActive = false;
    }
  }

  /// タイマー終了をローカル通知。こちらは使わない
  int _scheduleLocalNotification(Duration duration) {
    int notificationId =
        DateTime.now().hashCode; //現在時刻から生成しているが、通知を管理するIDを指定できる
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          android:
              AndroidInitializationSettings('@mipmap/ic_launcher'), //通知アイコン
          iOS: IOSInitializationSettings()),
      onSelectNotification: (payload) {
        //通知をタップされた時に行う処理
        StartUpProcess().startUp(notificationId);
        debugPrint(
            'flutterLocalNotificationsPlugin.initialize.${payload.toString()}');
      },
    );
    DateTime tzDT = tz.TZDateTime.now(tz.local).add(duration);
    flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, //通知のID
        'Time is over', //通知のタイトル
        'Wake up! It\'s ${formatTime(tzDT)}', //通知の本文
        tz.TZDateTime.now(tz.local).add(duration), //通知の予約時間
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.high,
                priority: Priority.high,
                //https://esffects.net/361.html からとってきた音源。
                //alarm2022\android\app\src\main\res\raw\simple_alarm_music.mp3 に配置。
                sound:
                    RawResourceAndroidNotificationSound('simple_alarm_music'),
                fullScreenIntent: true),
            iOS: IOSNotificationDetails()),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    debugPrint("■■■Scheduled for ${formatTime(tzDT)}");
    debugPrint("■■■         from ${formatTime(tz.TZDateTime.now(tz.local))}");
    return notificationId;
  }

  InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'), //通知アイコン
      iOS: IOSInitializationSettings());

  NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails('Alarm2022', 'Alarm2022',
          channelDescription: 'Alarm2022 by OUCC Hackathon group-A',
          importance: Importance.high,
          priority: Priority.high,
          //https://esffects.net/361.html からとってきた音源。
          //alarm2022\android\app\src\main\res\raw\simple_alarm_music.mp3 に配置。
          sound: RawResourceAndroidNotificationSound('simple_alarm_music'),
          fullScreenIntent: true),
      iOS: IOSNotificationDetails());

  /// タイマー終了をローカル通知。日時指定
  int scheduleNotification(int notificationId, DateTime datetime) {
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        //通知をタップされた時に行う処理
        StartUpProcess().startUp(notificationId);
        scheduleNotificationSnooze(notificationId);
        debugPrint(
            'flutterLocalNotificationsPlugin.initialize.${notificationId.toString()}');
      },
    );
    tz.TZDateTime tzDT = tz.TZDateTime.from(datetime, tz.local);
    flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, //通知のID
        'Time is over', //通知のタイトル
        'Wake up! It\'s ${formatTime(tzDT)}', //通知の本文
        tzDT, //通知の予約時間
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    debugPrint("■■■Scheduled for ${formatTime(tzDT)}");
    debugPrint("■■■         from ${formatTime(tz.TZDateTime.now(tz.local))}");
    debugPrint("■■■         from ${formatTime(DateTime.now())}");
    return notificationId;
  }

  /// タイマー終了をローカル通知。スヌーズ
  int scheduleNotificationSnooze(int notificationId) {
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        //通知をタップされた時に行う処理
        StartUpProcess().startUp(notificationId);
        debugPrint(
            'flutterLocalNotificationsPlugin.initialize.${notificationId.toString()}');
      },
    );
    flutterLocalNotificationsPlugin.periodicallyShow(
        notificationId, //通知のID
        'Time is already over', //通知のタイトル
        'This is Snooze ${formatTime(DateTime.now())}', //通知の本文
        RepeatInterval.everyMinute, //通知の予約時間
        notificationDetails,
        androidAllowWhileIdle: true);
    debugPrint("■■■ ${formatTime(DateTime.now())} Scheduled Snooze");
    return notificationId;
  }

  /// タイマー終了をローカル通知。実機デバッグ用の即時String通知
  int notice(String string) {
    int notificationId = -1;
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    flutterLocalNotificationsPlugin.show(
      notificationId, //通知のID
      'Notice (debug)', //通知のタイトル
      string, //通知の本文
      notificationDetails,
    );
    return notificationId;
  }
}
