import 'dart:convert';

class SharedAlarm {
  String sharedDataName = 'EARLIER_ALARM';
  String title = 'untitled';
  String time = '9:30';
  int minusMins = 10;
  String date = '2022-07-31';
  List<bool> selectedWeek = [];
  bool isOn = false;

  SharedAlarm({
    required this.sharedDataName,
    required this.title,
    required this.time,
    required this.minusMins,
    required this.date,
    required this.selectedWeek,
    required this.isOn,
  });

  static Map<String, dynamic> toMap(SharedAlarm sharedData) => {
        'sharedDataName': sharedData.sharedDataName,
        'title': sharedData.title,
        'time': sharedData.time,
        'minusMins': sharedData.minusMins,
        'date': sharedData.date,
        'selectedWeek': sharedData.selectedWeek,
        'isOn': sharedData.isOn,
      };

  factory SharedAlarm.fromJson(Map<String, dynamic> jsonData) {
    return SharedAlarm(
      sharedDataName: jsonData['sharedDataName'],
      title: jsonData['title'],
      time: jsonData['time'],
      minusMins: jsonData['minusMins'],
      date: jsonData['date'],
      selectedWeek: jsonData['selectedWeek'],
      isOn: jsonData['isOn'],
    );
  }

  static String encode(List<SharedAlarm> sharedData) => json.encode(
        sharedData
            .map<Map<String, dynamic>>(
                (sharedData) => SharedAlarm.toMap(sharedData))
            .toList(),
      );

  static List<SharedAlarm> decode(String sharedData) =>
      (json.decode(sharedData) as List<dynamic>)
          .map<SharedAlarm>((item) => SharedAlarm.fromJson(item))
          .toList();
}
