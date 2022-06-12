import 'package:flutter/material.dart';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:alarm2022/model/tongue_twister_questions.dart';

class TongueTwisterModel {
  //音声認識の実体
  stt.SpeechToText speech = stt.SpeechToText();

//表示用String
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  //時間計測用
  late DateTime? _startTime;
  late DateTime? _endTime;
  Duration speakDuration = const Duration();
  //判定表示用
  String message = "";
  bool isDoneLastTime = false;

//お題。RtQuestionを参照
  late TtQuestion question;

//音声認識開始
  Future<void> speak() async {
    //権限があるかなどを確認し初期化
    //アプリ起動につき1回のみ行う
    bool available = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (available) {
      //音声認識できるなら計測時間初期化して開始
      _startTime = null;
      speech.listen(onResult: resultListener, localeId: question.language);
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
  }

//音声認識終了。Androidでは一定時間話さなかったら自動的に終了するのであまり使われない
  Future<void> stop() async {
    speech.stop();
  }

//音声認識の結果を受け取る
  void resultListener(SpeechRecognitionResult result) {
    _startTime ??= DateTime.now();
    _endTime = DateTime.now();
    //経過時間を測定
    speakDuration = _endTime!.difference(_startTime!);
    //認識結果を保存
    lastWords = result.recognizedWords;
  }

//エラー時
  void errorListener(SpeechRecognitionError error) {
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

//状態(String)を受け取る。
//notListening, listening, done の3種
  void statusListener(String status) {
    lastStatus = status;
  }

//お題を変更。合わせて変数を初期化
  void resetQuestion() {
    lastWords = "";
    speakDuration = const Duration();
    message = "";
    question = ttQuestions[Random().nextInt(ttQuestions.length)];
  }

//音声認識が終了したか判断し評価を下す。終了判断はlastStatusの監視という力技
  void doneCheck() {
    //前回の状態を更新
    bool last = isDoneLastTime;
    isDoneLastTime = speech.lastStatus == "done";
    //今回doneになったら終了と判断
    if (last == false && isDoneLastTime) {
      if (lastWords.isEmpty) return;
      //判断部分
      //文字表示だけでなく成功時のエフェクトなども作りたい
      if (lastWords == question.pronounceQuestion) {
        message = "一致";
        return;
      }
      if (lastWords != question.pronounceQuestion) {
        message = "違う";
        return;
      }
      if (speakDuration.compareTo(question.limitTime) > 0) {
        message = "遅い";
        return;
      }
    }
  }
}
