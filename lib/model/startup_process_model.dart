import 'package:alarm2022/model/alarm_data.dart';
import 'package:alarm2022/view/CalculationProblem_s.dart';
import 'package:alarm2022/view/FakeTime.dart';
import 'package:alarm2022/view/tongue_twister_view.dart';
import 'package:alarm2022/view/newpage_template.dart';
import 'package:flutter/material.dart';
import 'ringing_alarm_model.dart';

class StartUpProcess {
  //このクラスでこれだけがアプリ起動時に呼ばれる
  void startUp(int nId) async {
    bool? isClearedMission;
    debugPrint("startUp");
    debugPrint("nId: $nId");

    isClearedMission = null;

    //鳴ってる通知の設定に従って小機能の呼び出し
    await startAMiniFunc(nId).then((value) {
      isClearedMission = value;
      //クリアしたなら予約キャンセル
      if (isClearedMission != null && isClearedMission!) {
        RingingAlarm().cancelNotification(nId);
        for (AlarmData alarmData in AlarmDataList.list) {
          if (alarmData.notificationId == nId) {
            DateTime dateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              alarmData.time.hour,
              alarmData.time.minute,
            );
            dateTime.add(const Duration(days: 1));

            RingingAlarm()
                .scheduleNotification(alarmData.notificationId, dateTime);
            break;
          }
        }
      }
    });
  }

  ///小機能に移る。情報の保存できてから引数とか追加
  Future<bool?> startAMiniFunc(int notificationId) async {
    debugPrint("startAMiniFunc");
    return await Navigator.of(CurrentContext.context!).push(
      MaterialPageRoute(builder: (context) {
        debugPrint("startAMiniFunc push");
        var cancelMethod = "";
        for (AlarmData alarmData in AlarmDataList.list) {
          if (alarmData.notificationId == notificationId) {
            cancelMethod = alarmData.cancelMethod;
            break;
          }
        }
        //実際は保存した設定を参照し、小機能を動かす
        switch (cancelMethod) {
          case "Calculation":
            return const CalculationProblemPage();
          case "FakeTime":
            return const FakeTime();
          case "TongueTwister":
            return const TongueTwisterPage();
          default:
            //こんな感じでswitch-caseで分岐
            //ここを移動先のクラスに変更
            //そのクラスから戻るときは
            //Navigator.of(context).pop(成功したかのbool);
            //を使って成功か否かを返してもらう
            return const NewPageTemp(
                title: 'New Page Temp from startAMiniPage');
        }
      }),
    );
  }
}

class CurrentContext extends StatelessWidget {
  const CurrentContext({Key? key}) : super(key: key);

  //あっちこっちでcontextを要求されるのが面倒なので置いとくためのもの。
  //このクラスはこれしか使わない。他のものは怒られないように置いてるだけ。
  //もっといい方法募集
  static BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}
