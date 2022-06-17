import 'package:flutter/material.dart';

class NewPageTemp extends StatefulWidget {
  const NewPageTemp({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _NewPageTempState createState() => _NewPageTempState();
}

class _NewPageTempState extends State<NewPageTemp> {
  int _counterNptmp = 0;

  void _incrementCounterNptmp() {
    setState(() {
      //画面内容を変更するならsetStateを呼ぶ必要がある。
      _counterNptmp++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ここにページのウィジェットを作っていきます。
      appBar: AppBar(
        //automaticallyImplyLeading: false,//これで上部の戻る矢印を消せる
        title: Text(widget.title ?? "Titleless NewPageTemp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counterNptmp',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'increment_button',
        onPressed: _incrementCounterNptmp,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
