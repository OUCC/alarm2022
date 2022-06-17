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
            // アラームを止める方法を選択する
            const Text(
              'アラームを止める方法を選択してください',
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: [
                RadioListTile(
                  value: "TongueTwister",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = value.toString();
                    });
                  },
                  title: const Text('トングUE TWISTER'),
                ),
                RadioListTile(
                  value: "FakeTime",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = value.toString();
                    });
                  },
                  title: const Text('FAKE TIME'),
                ),
                RadioListTile(
                  value: "Calculation",
                  groupValue: _alarmData.cancelMethod,
                  onChanged: (value) {
                    setState(() {
                      _alarmData.cancelMethod = value.toString();
                    });
                  },
                  title: const Text('計算'),
                )
              ],
            ),
            const SizedBox(height: 16),
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
            // テキスト入力
            const SizedBox(height: 8),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "pop"で前の画面に戻る
          // "pop"の引数から前の画面にデータを渡す
          Navigator.of(context).pop(_alarmData);
        },
        child: const Icon(Icons.add),
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
