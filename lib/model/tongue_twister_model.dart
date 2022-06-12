import 'package:flutter/material.dart';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:alarm2022/model/tongue_twister_questions.dart';

class TongueTwisterModel {
  String lastWords = "";
  String lastError = '';
  String lastStatus = '';
  stt.SpeechToText speech = stt.SpeechToText();

  late DateTime? _startTime;
  late DateTime? _endTime;
  Duration speakDuration = const Duration();
  String message = "";
  bool isDoneLastTime = false;

  late TtQuestion question;

  Future<void> speak() async {
    bool available = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (available) {
      _startTime = null;
      speech.listen(onResult: resultListener, localeId: question.language);
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
  }

  Future<void> stop() async {
    speech.stop();
  }

  void resultListener(SpeechRecognitionResult result) {
    _startTime ??= DateTime.now();
    _endTime = DateTime.now();
    speakDuration = _endTime!.difference(_startTime!);
    lastWords = result.recognizedWords;
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    lastStatus = status;
  }

  void resetQuestion() {
    lastWords = "";
    speakDuration = const Duration();
    message = "";
    question = ttQuestions[Random().nextInt(ttQuestions.length)];
  }

  void doneCheck() {
    bool last = isDoneLastTime;
    isDoneLastTime = speech.lastStatus == "done";
    if (last == false && isDoneLastTime) {
      if (lastWords.isEmpty) return;
      if (lastWords == question.pronounceQuestion) {
        message = "一致";
        return;
      }
      if (speakDuration.compareTo(question.limitTime) > 0) {
        message = "遅い";
        return;
      }
      if (lastWords != question.pronounceQuestion) {
        message = "違う";
        return;
      }
    }
  }
}
