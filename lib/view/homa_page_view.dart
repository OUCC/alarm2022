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
        itemCount: alarmDataList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const FlutterLogo(),
              title: Text(alarmDataList[index][0]),
              subtitle: Text(alarmDataList[index][1] ? '課題' : '起床'),
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
              final newListText = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return const AlarmAddPage();
                }),
              );
              if (newListText != null) {
                // キャンセルした場合は newListText が null となるので注意
                setState(() {
                  // リスト追加
                  alarmDataList.add([newListText, false]);
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
            child: const Icon(Icons.alarm),
          ),
        ],
      ),
    );
  }
}
