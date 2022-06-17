// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import '../model/alarm_data.dart';
import 'add_alarm_view.dart';
import 'ringing_alarm_view.dart';
import 'package:gap/gap.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'びっくりアラーム'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: AlarmDataList.list.length,
        itemBuilder: (context, index) {
          return Card(
            child: SwitchListTile(
              // 時刻を表示
              title: Text(AlarmDataList.list[index].time.format(context)),
              value: AlarmDataList.list[index].isValid,
              onChanged: (value) {
                setState(() {
                  AlarmDataList.list[index].isValid = value;
                  AlarmDataList.save();
                  print(AlarmDataList.list[index].cancelMethod);
                });
              },
              subtitle: Text(AlarmDataList.list[index].cancelMethod),
              // calculation icon
              secondary:
                  alarmStopMethodIcon[AlarmDataList.list[index].cancelMethod],
            ),
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
              final alarmData = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return const AlarmAddPage();
                }),
              );
              if (alarmData != null) {
                // キャンセルした場合は newListText が null となるので注意
                setState(() {
                  // リスト追加
                  AlarmDataList.add(alarmData);
                });
              }
            },
            child: const Icon(Icons.add),
          ),
          const Gap(16),
          FloatingActionButton(
            // ringing_alarm_pageに飛ぶボタン
            heroTag: 'ringing_alarm_page_button',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RingingAlarmTestPage(),
                ),
              );
            },
            child: const Icon(Icons.running_with_errors),
          ),
          const Gap(16),
          FloatingActionButton(
            // アラームを保存するボタン
            heroTag: 'save_button',
            onPressed: () {
              setState(() {
                AlarmDataList.save();
              });
            },
            child: const Icon(Icons.save),
          ),
          const Gap(16),
          FloatingActionButton(
            // load
            heroTag: 'load_button',
            onPressed: () {
              setState(() {
                AlarmDataList.load();
              });
            },
            child: const Icon(Icons.file_download),
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
