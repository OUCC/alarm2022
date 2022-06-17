import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class CalculationProblemPage extends StatefulWidget {
  const CalculationProblemPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _CalculationProblemPageState createState() => _CalculationProblemPageState();
}

class _CalculationProblemPageState extends State<CalculationProblemPage> {
  //四則演算の決定用乱数(0は足し算,1は引き算,2は掛け算,3は割り算に対応)
  var calculation = math.Random().nextInt(4);
  //3桁の整数を乱数で生成(和、差用)
  var rand1 = math.Random().nextInt(900) + 100;
  var rand2 = math.Random().nextInt(900) + 100;
  //2桁の整数を乱数で生成(積、商用)
  var rand3 = math.Random().nextInt(90)+10;
  var rand4 = math.Random().nextInt(90)+10;
  //和
  get sum => rand1 + rand2;
  //差
  get difference => rand1 - rand2;
  //積
  get product => rand3 * rand4;
  //入力を入れる変数
  var _answer = '';
  //連続正解数のカウント
  var counter = 0;
  //「ミス！」のフェードアウト
  bool _visible = false;
  //ミス！の上下移動
  var  _alignment = Alignment.topCenter;
  //TextFieldをクリア
  final _controller = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(10),
                child:Text(
                    '3問連続で正解しなさい\n(現在連続$counter問正解中)',
                    style: const TextStyle(fontSize:25),
                    textAlign: TextAlign.center
                )
            ),
            //重ねて表示
            Stack(
              children: [
                //表示をcalculationの値によって変更
                Container(
                  height: 100.0,
                  width: 200.0,
                  alignment: const Alignment(0, 0),
                  child:(() {
                    if (calculation==0) {
                      return Text(
                          '$rand1+$rand2=',
                          style: const TextStyle(fontSize: 40)
                      );
                    }
                    else if(calculation==1) {
                      return Text(
                          '$rand1-$rand2=',
                          style: const TextStyle(fontSize: 40)
                      );
                    }
                    else if(calculation==2) {
                      return Text(
                          '$rand3×$rand4=',
                          style: const TextStyle(fontSize: 40)
                      );
                    }
                    else {
                      return Text(
                          '$product÷$rand3=',
                          style: const TextStyle(fontSize: 40)
                      );
                    }
                  })(),
                ),
                SizedBox(
                  height: 100.0,
                  width: 200.0,
                  //画面に「ミス！」を配置,_visibleで表示を切り替える,_alignmentで上下移動
                  child:AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Text(
                        'ミス！',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:30,
                            color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            TextField(
              onChanged: (var value){
                setState((){
                  //入力を_answerに代入,「ミス！」の表示を消す
                  _answer =value;
                  _visible = false;
                  _alignment = Alignment.topCenter;
                });
                },
              controller: _controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '解答を入力'
              ),
              keyboardType: TextInputType.number,
              //-と0~9だけ入力を受け付ける
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-]'))],
            ),
            const SizedBox(height: 8),

            //解答ボタン
            ElevatedButton(
              onPressed: () {
                //TextFieldをクリア
                _controller.clear();
                if( //二連続では正解しておらず,正しい答えを入力
                         counter != 2&&
                       ((calculation==0 && _answer == '$sum')||
                        (calculation==1 && _answer == '$difference')||
                       (calculation==2 && _answer == '$product')||
                       (calculation==3 && _answer == '$rand4')))
                {//counterを増やす
                  counter++;
                }
                else if (//二連続正解かつ正しい答えを入力
                        counter == 2 &&
                      ((calculation==0 && _answer == '$sum')||
                       (calculation==1 && _answer == '$difference')||
                       (calculation==2 && _answer == '$product')||
                       (calculation==3 && _answer == '$rand4')))
                {//前のページに戻す
                   Navigator.of(context).pop();
                }
                else{//答えが間違っていればcounterを0にして「ミス！」と表示
                  counter =0;
                  _visible = true;
                  _alignment = Alignment.bottomCenter;
                }
                //処理が終わると乱数し直して読み込みなおす
                setState((){
                  calculation = math.Random().nextInt(4);
                  rand1 = math.Random().nextInt(900) + 100;
                  rand2 = math.Random().nextInt(900) + 100;
                  rand3 = math.Random().nextInt(90) + 10;
                  rand4 = math.Random().nextInt(90) + 10;
                });
                },
              child: const Text('解答'),
            ),
      ],
        ),
      ),
    );
  }
}

