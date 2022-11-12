import 'dart:convert';

class Alarm {
  String id;
  String title;
  String time;
  int difference;
  String calculatedTime;
  String date;
  List<bool> selectedWeek;
  bool isOn;

  Alarm({
    required this.id,
    required this.title,
    required this.time,
    required this.difference,
    required this.calculatedTime,
    required this.date,
    required this.selectedWeek,
    required this.isOn,
  });

  static Map<String, dynamic> toMap(Alarm alarm) => {
        'id': alarm.id,
        'title': alarm.title,
        'time': alarm.time,
        'difference': alarm.difference,
        'calculatedTime': alarm.calculatedTime,
        'date': alarm.date,
        'selectedWeek': alarm.selectedWeek,
        'isOn': alarm.isOn,
      };

  factory Alarm.fromJson(Map<String, dynamic> jsonData) {
    return Alarm(
      id: jsonData['id'],
      title: jsonData['title'],
      time: jsonData['time'],
      difference: jsonData['difference'],
      calculatedTime: jsonData['calculatedTime'],
      date: jsonData['date'],
      selectedWeek: jsonData['selectedWeek'],
      isOn: jsonData['isOn'],
    );
  }

  static String encode(List<Alarm> alarmList) => json.encode(
        alarmList
            .map<Map<String, dynamic>>(
                (sharedData) => Alarm.toMap(sharedData))
            .toList(),
      );

  static List<Alarm> decode(String alarm) =>
      (json.decode(alarm) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}
