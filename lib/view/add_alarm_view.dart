import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../model/alarm_data.dart';

class AlarmAddPage extends StatefulWidget {
  const AlarmAddPage({Key? key}) : super(key: key);

  @override
  State<AlarmAddPage> createState() => _AlarmAddPageState();
}

class _AlarmAddPageState extends State<AlarmAddPage> {
  // 入力された情報を持つ
  final _alarmData = AlarmData(
    time: const TimeOfDay(hour: 0, minute: 0),
    cancelMethod: "TongueTwister",
    isValid: true,
    notificationId: Random().nextInt(100000000),
  );

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム追加'),
      ),
      body: Container(
        // 余白を付ける
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 時刻を表示
            Text(
              _alarmData.time.format(context),
              style: const TextStyle(fontSize: 48),
            ),
            // 時刻を入力するテキストフィールド
            ElevatedButton(
              child: const Text('時刻を入力'),
              onPressed: () {
                _selectTime(context);
              },
            ),
            const SizedBox(height: 16),
            // アラームを止める方法を選択する
            const Text(
              'アラームを止める方法',
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: [
                RadioListTile(
                  value: "TongueTwister",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = "TongueTwister";
                    });
                  },
                  title: const Text('Tongue Twister'),
                ),
                RadioListTile(
                  value: "FakeTime",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = "FakeTime";
                    });
                  },
                  title: const Text('Fake Time'),
                ),
                RadioListTile(
                  value: "Calculation",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = "Calculation";
                    });
                  },
                  title: const Text('Calculation'),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
                onPressed: () {
                  // "pop"で前の画面に戻る
                  // "pop"の引数から前の画面にデータを渡す
                  Navigator.of(context).pop(_alarmData);
                },
                child:
                    const Text('アラーム追加', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        _alarmData.time = timeOfDay;
      });
    }
  }
}
