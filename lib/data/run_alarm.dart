// import 'dart:async';
//
// import 'package:earlier_alarm/alert_alarm.dart';
// import 'package:earlier_alarm/data/datetime_format.dart';
// import 'package:earlier_alarm/data/my_position.dart';
// import 'package:earlier_alarm/data/weather_conditions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
//
// class RunAlarm {
//   Timer runAlarm(BuildContext context) {
//     return Timer.periodic(Duration(minutes: 1), (timer) async {
//       List<String> _alarmList = [];
//       List<String> _calculatedAlarmList = [];
//       for (var alarm in sharedDataList) {
//         if (alarm.isOn) {
//           if (alarm.date.contains(DateTimeFormat.getToday()) &&
//               !DateTimeFormat.isContain(alarm.selectedWeek)) {
//             _alarmList.add(alarm.time);
//             _calculatedAlarmList.add(alarm.calculatedTime);
//           } else {
//             if (DateTimeFormat.getWeekday(selectedWeek)) {
//               _alarmList.add(alarm.time);
//               _calculatedAlarmList.add(alarm.calculatedTime);
//             }
//           }
//         }
//       }
//       String _currentTime = DateTimeFormat.getSystemTime();
//       if (_calculatedAlarmList.contains(_currentTime)) {
//         MyPosition myPosition = MyPosition();
//         Map map = await myPosition.getPosition();
//         int condition = map['condition'];
//         WeatherConditions weatherConditions = WeatherConditions();
//         if (weatherConditions.isRainOrSnow(condition)) {
//           playAlarm(context);
//         }
//       } else {
//         if (_alarmList.contains(_currentTime)) {
//           playAlarm(context);
//         }
//       }
//     });
//   }
//
//   void playAlarm(BuildContext context) {
//     FlutterRingtonePlayer.playAlarm(volume: 5, looping: true, asAlarm: true);
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return const AlertAlarm();
//     }));
//   }
//
// }