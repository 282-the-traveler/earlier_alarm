import 'package:earlier_alarm/common/datetime_format.dart';
import 'package:earlier_alarm/model/alarm.dart';
import 'package:flutter/material.dart';

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarmList = [];
  int _index = 0;
  Alarm _alarm = Alarm(
    id: 'EARLIER_ALARM',
    title: '',
    time: DateTimeFormat.getSystemTime(),
    difference: 30,
    calculatedTime:
    DateTimeFormat.getCalculatedTime(DateTimeFormat.getSystemTime(), 30),
    date: DateTimeFormat.getTomorrow(),
    selectedWeek: List.generate(
      7,
          (index) => false,
    ),
    isOn: true,
  );
  bool _isOn = true;

  List<Alarm> get alarmList => _alarmList;

  int get index => _index;

  Alarm get sharedAlarm => _alarm;

  bool get isOn => _isOn;

  void setAlarmDataList(List<Alarm> value) {
    _alarmList = value;
    notifyListeners();
  }

  void setIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void setAlarm(Alarm value) {
    _alarm = value;
    notifyListeners();
  }

  void addAlarm(Alarm sharedAlarm) {
    _alarmList.add(sharedAlarm);
    notifyListeners();
  }

  Alarm disposeAlarm() {
    _alarm = Alarm(
      id: 'EARLIER_ALARM',
      title: '',
      time: DateTimeFormat.getSystemTime(),
      difference: 30,
      calculatedTime:
      DateTimeFormat.getCalculatedTime(DateTimeFormat.getSystemTime(), 30),
      date: DateTimeFormat.getTomorrow(),
      selectedWeek: List.generate(
        7,
            (index) => false,
      ),
      isOn: true,
    );
    return _alarm;
  }

  void setIsOn(bool value) {
    _alarmList[_index].isOn = value;
    notifyListeners();
  }

  void removeAlarm(int value) {
    _alarmList.removeAt(value);
    notifyListeners();
  }
}
