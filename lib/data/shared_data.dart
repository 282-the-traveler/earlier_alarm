import 'dart:convert';

class SharedData {
  String sharedDataName = 'EARLIER_ALARM';
  String id = '9:30\-10';
  String title = 'untitled';
  String time = '9:30';
  int minusMins = 10;
  String date = '2022-07-31';
  bool isOn = false;

  // var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  SharedData({
    required this.sharedDataName,
    required this.id,
    required this.title,
    required this.time,
    required this.minusMins,
    required this.date,
    required this.isOn,
  });

  // required this.week});

  static Map<String, dynamic> toMap(SharedData sharedData) => {
        'sharedDataName': sharedData.sharedDataName,
        'id': sharedData.id,
        'title': sharedData.title,
        'time': sharedData.time,
        'minusMins': sharedData.minusMins,
        'date': sharedData.date,
        'isOn': sharedData.isOn,
        // 'week': sharedData.week,
      };

  factory SharedData.fromJson(Map<String, dynamic> jsonData) {
    return SharedData(
      sharedDataName: jsonData['sharedDataName'],
      id: jsonData['id'],
      title: jsonData['title'],
      time: jsonData['time'],
      minusMins: jsonData['minusMins'],
      date: jsonData['date'],
      isOn: jsonData['isOn'],
      // week: jsonData['week'],
    );
  }

  static String encode(List<SharedData> sharedData) => json.encode(
        sharedData
            .map<Map<String, dynamic>>(
                (sharedData) => SharedData.toMap(sharedData))
            .toList(),
      );

  static List<SharedData> decode(String sharedData) =>
      (json.decode(sharedData) as List<dynamic>)
          .map<SharedData>((item) => SharedData.fromJson(item))
          .toList();
}
