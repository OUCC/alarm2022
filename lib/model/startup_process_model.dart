import 'package:alarm2022/view/newpage_template.dart';
import 'package:flutter/material.dart';
import 'ringing_alarm_model.dart';

class StartUpProcess {
  //このクラスでこれだけがアプリ起動時に呼ばれる
  void startUp(int? nId) {
    bool? isClearedMission;
    debugPrint("startUp");

    isClearedMission = null;
    //鳴ってる通知の設定に従って小機能の呼び出し
    if (nId != null) {
      startAMiniFunc().then((value) {
        isClearedMission = value;
        //クリアしたなら予約キャンセル
        if (isClearedMission != null && isClearedMission!) {
          RingingAlarm().cancelNotification(nId);
        }
      });
    }
  }

  ///小機能に移る。情報の保存できてから引数とか追加
  Future<bool?> startAMiniFunc() async {
    return await Navigator.of(CurrentContext.context!).push(
      MaterialPageRoute(builder: (context) {
        //実際は保存した設定を参照し、小機能を動かす
        switch (0) {
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
