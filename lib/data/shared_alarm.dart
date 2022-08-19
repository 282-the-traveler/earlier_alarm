import 'dart:convert';

class SharedAlarm {
  String sharedDataName = 'EARLIER_ALARM';
  String title = 'untitled';
  String time = '9:30';
  int difference = 10;
  String calculatedTime;
  String date = '2022-07-31';
  List<bool> selectedWeek = [];
  bool isOn = false;

  SharedAlarm({
    required this.sharedDataName,
    required this.title,
    required this.time,
    required this.difference,
    required this.calculatedTime,
    required this.date,
    required this.selectedWeek,
    required this.isOn,
  });

  static Map<String, dynamic> toMap(SharedAlarm sharedData) => {
        'sharedDataName': sharedData.sharedDataName,
        'title': sharedData.title,
        'time': sharedData.time,
        'difference': sharedData.difference,
        'calculatedTime': sharedData.calculatedTime,
        'date': sharedData.date,
        'selectedWeek': sharedData.selectedWeek,
        'isOn': sharedData.isOn,
      };

  factory SharedAlarm.fromJson(Map<String, dynamic> jsonData) {
    return SharedAlarm(
      sharedDataName: jsonData['sharedDataName'],
      title: jsonData['title'],
      time: jsonData['time'],
      difference: jsonData['difference'],
      calculatedTime: jsonData['calculatedTime'],
      date: jsonData['date'],
      selectedWeek: jsonData['selectedWeek'],
      isOn: jsonData['isOn'],
    );
  }

  static String encode(List<SharedAlarm> sharedDataList) => json.encode(
        sharedDataList
            .map<Map<String, dynamic>>(
                (sharedData) => SharedAlarm.toMap(sharedData))
            .toList(),
      );

  static List<SharedAlarm> decode(String sharedData) =>
      (json.decode(sharedData) as List<dynamic>)
          .map<SharedAlarm>((item) => SharedAlarm.fromJson(item))
          .toList();
}
