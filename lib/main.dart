import 'package:flutter/material.dart';
import 'model/ringing_alarm_model.dart';
import 'view/ringing_alarm_view.dart';
import 'view/tongue_twister_view.dart';

void main() async {
  setupRingingAlarm();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool? ttIsCleared;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              //RingingAlarmPageに飛ぶボタン
              heroTag: 'ringing_alarm_page_button',
              onPressed: () async {
                // "push"で新規画面に遷移
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const RingingAlarmTestPage(
                        title: 'Ringing Alarm Test Page');
                  }),
                );
              },
              child: const Icon(Icons.alarm),
            ),
            FloatingActionButton(

              heroTag: 'tongue_twister_page_button',
              onPressed: () async {
                ttIsCleared = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const TongueTwisterPage();
                  }),
                );
                setState(() {});
              },
              child: const Icon(Icons.mic),
            ),
            Text(
              "早口言葉:${ttIsCleared == null ? "未成功" : (ttIsCleared! ? "成功" : "失敗")}",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}
