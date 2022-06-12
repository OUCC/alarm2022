import 'package:flutter/material.dart';
import 'dart:async';
import 'package:alarm2022/model/tongue_twister_model.dart';

class TongueTwisterPage extends StatefulWidget {
  const TongueTwisterPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _TongueTwisterPageState createState() => _TongueTwisterPageState();
}

class _TongueTwisterPageState extends State<TongueTwisterPage> {
  //modelの方の実体
  TongueTwisterModel ttm = TongueTwisterModel();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    ttm.resetQuestion();
    //表示更新用タイマー
    Timer.periodic(const Duration(milliseconds: 100), (Timer clockTimer) {
      setState(() {
        ttm.doneCheck();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tongue Twister"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'お題',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              ttm.question.displayQuestion,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              '認識',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              ttm.lastWords,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'ステータス : ${ttm.speech.lastStatus}',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              '時間 : ${ttm.speakDuration.inMilliseconds ~/ 100 / 10} s',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '評価:${ttm.message}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            heroTag: "tt_back",
            onPressed: () {
              Navigator.of(context).pop(ttm.message == "一致");
            },
            child: const Icon(Icons.arrow_back)),
        FloatingActionButton(
            heroTag: "tt_changeQuestion",
            onPressed: ttm.resetQuestion,
            child: const Icon(Icons.cached)),
        FloatingActionButton(
            heroTag: "tt_play",
            onPressed: ttm.speak,
            child: const Icon(Icons.play_arrow)),
        FloatingActionButton(
            heroTag: "tt_stop",
            onPressed: ttm.stop,
            child: const Icon(Icons.stop))
      ]),
    );
  }
}
