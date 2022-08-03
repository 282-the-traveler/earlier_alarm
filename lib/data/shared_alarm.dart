import 'dart:convert';

import 'package:earlier_alarm/data/earlier_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  String id = '9:30\-10';
  String title = 'untitled';
  String time = '9:30';
  String minusMins = '10';
  String date = '20220731';

  // var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  SharedData({
    required this.id,
    required this.title,
    required this.time,
    required this.minusMins,
    required this.date,
  });

  // required this.week});

  static Map<String, dynamic> toMap(SharedData sharedData) => {
        'id': sharedData.id,
        'title': sharedData.title,
        'time': sharedData.time,
        'minusMins': sharedData.minusMins,
        'date': sharedData.date,
        // 'week': sharedData.week,
      };

  factory SharedData.fromJson(Map<String, dynamic> jsonData) {
    return SharedData(
      id: jsonData['id'],
      title: jsonData['title'],
      time: jsonData['time'],
      minusMins: jsonData['minusMins'],
      date: jsonData['date'],
      // week: jsonData['week'],
    );
  }

  static String encode(List<SharedData> sharedData) => json.encode(
        sharedData
            .map<Map<String, dynamic>>((music) => SharedData.toMap(music))
            .toList(),
      );

  static List<SharedData> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<SharedData>((item) => SharedData.fromJson(item))
          .toList();
}
