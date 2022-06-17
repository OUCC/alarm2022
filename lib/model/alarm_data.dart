import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmData {
  TimeOfDay time;
  String cancelMethod;
  bool isValid;
  int notificationId;

  AlarmData(
      {required this.time,
      required this.cancelMethod,
      required this.isValid,
      required this.notificationId});

  static AlarmData fromJson(Map<String, dynamic> json) {
    return AlarmData(
        time: json['time'],
        cancelMethod: json['cancelMethod'],
        isValid: json['isValid'],
        notificationId: json['notificationId']);
  }

  Map<String, dynamic> toJson() => {
        "time": time,
        "cancelMethod": cancelMethod,
        "isValid": isValid,
        "notificationId": notificationId,
      };
}

class AlarmDataList {
  static List<AlarmData> list = [];

  static void add(AlarmData alarmData) {
    list.add(alarmData);
  }

  static void remove(AlarmData alarmData) {
    list.remove(alarmData);
  }

  static void clear() {
    list.clear();
  }

  static void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('alarmDataList', json.encode(list));
  }

  static Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? alarmDataListJson = prefs.getString('alarmDataList');
    if (alarmDataListJson != null) {
      list = json
          .decode(alarmDataListJson)
          .map<AlarmData>((json) => AlarmData.fromJson(json))
          .toList();
    }
  }

  get length => list.length;
}
