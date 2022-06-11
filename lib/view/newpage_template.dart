import 'package:flutter/material.dart';

class NewPageTemp extends StatefulWidget {
  const NewPageTemp({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _NewPageTempState createState() => _NewPageTempState();
}

class _NewPageTempState extends State<NewPageTemp> {
  int _counter_nptmp = 0;

  void _incrementCounter_nptmp() {
    setState(() {
      //画面内容を変更するならsetStateを呼ぶ必要がある。
      _counter_nptmp++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ここにページのウィジェットを作っていきます。
      appBar: AppBar(
        title: Text("NewPage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter_nptmp',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'increment_button',
        onPressed: _incrementCounter_nptmp,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
