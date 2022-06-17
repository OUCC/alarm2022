import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'dart:async';


class FakeTime extends StatefulWidget {
  const FakeTime({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _FakeTimeState createState() => _FakeTimeState();
}

class _FakeTimeState extends State<FakeTime> {
  
  var test_value;
  Timer? _testtimer;
    void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
    //現在時刻表示用だが画面の更新処理も担っている
    test_value = DateTime.now();
    _testtimer =
        Timer.periodic(const Duration(milliseconds: 100), (Timer clockTimer) {
      setState(() {
        test_value = DateTime.now().add(Duration(hours:2));
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(      
      body: Center(            
        child:Container(
          padding: const EdgeInsets.only(top:100),
       // alignment: Alignment.topCenter,
          width: _width,
          height: _height,
          color: const Color.fromARGB(255, 3, 5, 128),
          child:Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: const Alignment(0,1),
                child:Text(
                  DateFormat('kk:mm').format(test_value),
                  style: const TextStyle(
                    color:Colors.white,
                    fontSize: 60                 
                  ),              
                ),
              ),
              const Text(
                'アラーム',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                
                    padding: const EdgeInsets.only(top:200),
                    child:const Icon(
                      Icons.snooze,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                
                    padding: const EdgeInsets.only(top:200),
                    child:const Icon(
                      Icons.alarm,
                      size: 50,
                      color: Colors.white,
                    ),
                
              
                  ),
                  Container(
                    padding: const EdgeInsets.only(top:200),
                    child:const Icon(
                    Icons.alarm_off,
                    size: 50,
                    color: Colors.white,
                    ),
                  )
                ]
              )
            ],
          ),
        )
      )
    );    
  }
}


//メモ　alarm_off ,  alarm , snooze , 
