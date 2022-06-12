import 'package:flutter/material.dart';

class TtQuestion {
  TtQuestion(this.displayQuestion, this.limitSecond,
      {this.pronounce, this.english = false});
  final String displayQuestion;
  final double limitSecond;

  ///初期化専用。pronounceQuestionを使うこと。
  final String? pronounce;
  final bool english;

  Duration get limitTime {
    return Duration(seconds: limitSecond.toInt()) +
        Duration(
            milliseconds: ((limitSecond - limitSecond.toInt()) * 1000).toInt());
  }

  String get pronounceQuestion {
    return pronounce ?? displayQuestion;
  }

  String? get language {
    return english ? const Locale('en').toLanguageTag() : null;
  }
}

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
