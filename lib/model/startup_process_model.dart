import 'package:alarm2022/view/newpage_template.dart';
import 'package:flutter/material.dart';
import 'ringing_alarm_model.dart';

class StartUpProcess {
  //このクラスでこれだけがアプリ起動時に呼ばれる
  void startUp() {
    RingingAlarm ringingAlarm = RingingAlarm();
    int? ringingId;
    bool? isClearedMission;
    //まず通知の状態を取得
    List<int>? notificationIds = idOfRingingNowAlarm();
    //鳴っている通知を止める
    if (notificationIds != null) {
      for (var nId in notificationIds) {
        //鳴ってるidを取得
        ringingId = nId;
      }
    }
    //鳴ってる通知の設定に従って小機能の呼び出し
    if (ringingId != null) {
      isClearedMission = startAMiniFunc();
    }
    //クリアしたなら通知消去
    if (isClearedMission != null && isClearedMission) {
      ringingAlarm.delateNotification(ringingId);
    }
  }

  ///現在鳴っている通知のIdを返す。
  ///- 鳴っていなかったらnullを返す。
  ///- アプリ起動時に使用予定
  List<int>? idOfRingingNowAlarm() {
    List<int>? notificationIds;
    //アラームの情報の保存とかができてから詰める

    return notificationIds;
  }

  ///小機能に移る。情報の保存できてから引数とか追加
  bool? startAMiniFunc() {
    bool? isClearedMission;
    //なんか非同期のラムダ式がうまくいかなかった（呼び出されていない？）ので
    //変なことになっていますが、気にしないでください。（修正募集）
    Future<void> _a() async {
      isClearedMission = await Navigator.of(CurrentContext.context!).push(
        MaterialPageRoute(builder: (context) {
          //ランダムで小機能に移る。実際は保存した設定を参照
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

    _a();
    return isClearedMission;
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
