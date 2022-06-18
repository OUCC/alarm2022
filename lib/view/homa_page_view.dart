// ignore_for_file: unnecessary_const

import 'package:alarm2022/model/startup_process_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/alarm_data.dart';
import 'add_alarm_view.dart';
import '../model/ringing_alarm_model.dart';
import 'ringing_alarm_view.dart';
import 'package:gap/gap.dart';
import 'tongue_twister_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentContext.context = context;
    //初期化処理
    for (var alarmData in AlarmDataList.list) {
      var dateTime = TimeOfDayToDateTime(alarmData.time);
      if (DateTime.now().compareTo(dateTime) < 0) {
        dateTime.add(const Duration(days: 1));
      }
      if (alarmData.isValid) {
        RingingAlarm().scheduleNotification(alarmData.notificationId, dateTime);
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'アラームを止めろ！'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentContext.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: AlarmDataList.list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            child: SwitchListTile(
              // 時刻を表示
              title: Text(AlarmDataList.list[index].time.format(context)),
              value: AlarmDataList.list[index].isValid,
              onChanged: (value) {
                setState(() {
                  AlarmDataList.list[index].isValid = value;
                  AlarmDataList.save();
                  var dateTime =
                      TimeOfDayToDateTime(AlarmDataList.list[index].time);
                  if (DateTime.now().compareTo(dateTime) < 0) {
                    dateTime.add(const Duration(days: 1));
                  }
                  if (AlarmDataList.list[index].isValid) {
                    RingingAlarm().scheduleNotification(
                        AlarmDataList.list[index].notificationId, dateTime);
                  } else {
                    RingingAlarm().cancelNotification(
                        AlarmDataList.list[index].notificationId);
                  }
                });
              },
              subtitle: Text(AlarmDataList.list[index].cancelMethod),
              // calculation icon
              secondary:
                  alarmStopMethodIcon[AlarmDataList.list[index].cancelMethod],
            ),
            onDismissed: (direction) {
              setState(() {
                // Alarm cancel
                RingingAlarm().cancelNotification(
                    AlarmDataList.list[index].notificationId);
                AlarmDataList.list.removeAt(index);
                AlarmDataList.save();
              });
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            //AlarmAddPageに飛ぶボタン
            heroTag: 'alarm_add_page_button',
            onPressed: () async {
              AlarmData alarmData = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return const AlarmAddPage();
                }),
              );
              setState(() {
                // リスト追加
                AlarmDataList.add(alarmData);
                AlarmDataList.save();
                // TimeOfDayをDateTimeに変換
                var dateTime = TimeOfDayToDateTime(alarmData.time);
                if (DateTime.now().compareTo(dateTime) < 0) {
                  dateTime.add(const Duration(days: 1));
                }

                RingingAlarm()
                    .scheduleNotification(alarmData.notificationId, dateTime);
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

var alarmStopMethodIcon = {
  'Calculation': const Icon(Icons.calculate),
  'FakeTime': const Icon(Icons.running_with_errors),
  'TongueTwister': const Icon(Icons.keyboard_voice),
};

// ignore: non_constant_identifier_names
DateTime TimeOfDayToDateTime(TimeOfDay timeOfDay) {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}
