import 'package:flutter/material.dart';
import 'dart:async';
import '../model/ringing_alarm_model.dart';

//新しく作り直すと考えTestとつけている
class RingingAlarmTestPage extends StatefulWidget {
  const RingingAlarmTestPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _RingingAlarmTestPageState createState() => _RingingAlarmTestPageState();
}

class _RingingAlarmTestPageState extends State<RingingAlarmTestPage>
    with WidgetsBindingObserver {
  //modelの方の実体
  final RingingAlarm _ringingAlarm = RingingAlarm();
  //現在時刻表示用のTimer
  Timer? _clockTimer;

  //ページ遷移時にlogがバグったので。
  //参照：https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /// 初期化処理
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //現在時刻表示用だが画面の更新処理も担っている
    _clockTimer =
        Timer.periodic(const Duration(milliseconds: 100), (Timer clockTimer) {
      setState(() {});
    });
  }

  /// ライフサイクルが変更された際に呼び出される関数をoverrideして、変更を検知
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // バックグラウンドに遷移した時
      setState(() {
        _ringingAlarm.handleOnPaused();
      });
    } else if (state == AppLifecycleState.resumed) {
      // フォアグラウンドに復帰した時
      setState(() {
        _ringingAlarm.handleOnResumed();
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        //現在時刻表示
        "Now : ${formatTime(DateTime.now())}",
      ),
      Text(
        //タイマー表示
        formatTime(_ringingAlarm.displayTime),
        style: Theme.of(context).textTheme.headline2,
      ),
      Row(
        //各種ボタンの配置
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            //前の画面に戻る
            heroTag: 'back_button',
            onPressed: () {
              if (_clockTimer != null) _clockTimer!.cancel();
              Navigator.of(context).pop();
            },
            child: const Text("Back"),
          ),
          FloatingActionButton(
            //タイマーの一時停止
            heroTag: 'stop_button',
            onPressed: () {
              _ringingAlarm.cancelTimer();
            },
            child: const Text("Stop"),
          ),
          FloatingActionButton(
            //タイマーのカウントダウン再開
            heroTag: 'start_button',
            onPressed: () {
              _ringingAlarm.startTimer();
            },
            child: const Text("Start"),
          ),
          FloatingActionButton(
            //タイマーの時間をリセットしてスタート
            heroTag: 'restart_button',
            onPressed: () {
              _ringingAlarm.restartTimer();
            },
            child: const Text("Restart"),
          ),
          FloatingActionButton(
            //鳴ってるアラームを止める
            heroTag: 'reset_button',
            onPressed: () {
              _ringingAlarm.resetNotification();
            },
            child: const Text("Reset"),
          ),
        ],
      )
    ]));
  }
}
