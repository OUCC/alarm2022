import 'package:flutter/material.dart';

class TtQuestion {
  ///お題
  TtQuestion(
    this.displayQuestion,
    this.limitSecond, {
    this.pronounce,
    this.english = false,
  });

  ///お題の文
  final String displayQuestion;

  ///制限時間
  ///- 初期化専用。limitTimeを使うこと。
  final double limitSecond;

  ///音声認識結果がお題の分と違ってしまうとき(変換、句読点など)の認識される文
  ///- 初期化専用。pronounceQuestionを使うこと。
  final String? pronounce;

  ///英語で認識
  final bool english;

  ///制限時間(参照用)
  Duration get limitTime {
    return Duration(seconds: limitSecond.toInt()) +
        Duration(
            milliseconds: ((limitSecond - limitSecond.toInt()) * 1000).toInt());
  }

  ///音声認識結果がお題の分と違ってしまうとき(変換、句読点など)の認識される文
  String get pronounceQuestion {
    return pronounce ?? displayQuestion;
  }

  ///認識する言語
  String? get language {
    return english ? const Locale('en').toLanguageTag() : null;
  }
}

///問題文一覧
List<TtQuestion> ttQuestions = [
  TtQuestion("生麦生米生卵", 2.5),
  TtQuestion("隣の客はよく柿食う客だ", 2.5),
  TtQuestion("スモモも桃も桃のうち", 2.5, pronounce: "すもももももももものうち"),
  TtQuestion("東京特許許可局長今日急遽休暇許可拒否", 4),
  TtQuestion("I scream, you scream, we all scream for ice cream!", 3.5,
      pronounce: "I scream you scream we all scream for ice cream",
      english: true),
  TtQuestion(
    "パブロ・ディエゴ・ホセ・フランシスコ・デ・パウラ・ホアン・ネポムセーノ・チプリアーノ・デ・ラ・サンティシマ・トリニダード・ルイス・ピカソ",
    9,
    pronounce: "パブロディエゴホセフランシスコデパウラホアンネポムセーノチプリアーニデラサンティシマトリニダードルイスピカソ",
  ),
];
