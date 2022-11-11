import 'package:earlier_alarm/data/datetime_format.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedProvider extends ChangeNotifier {
  List<SharedAlarm> _sharedDataList = [];
  int _index = 0;
  SharedAlarm _sharedAlarm = SharedAlarm(
    sharedDataName: 'EARLIER_ALARM',
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

  List<SharedAlarm> get sharedDataList => _sharedDataList;

  int get index => _index;

  SharedAlarm get sharedAlarm => _sharedAlarm;

  void setSharedDataList(List<SharedAlarm> value) {
    _sharedDataList = value;
    notifyListeners();
  }

  void setIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void setSharedAlarm(SharedAlarm value) {
    _sharedAlarm = value;
    notifyListeners();
  }

  void addSharedData(SharedAlarm sharedAlarm) {
    _sharedDataList.add(sharedAlarm);
    notifyListeners();
  }

  void saveList() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_sharedDataList[_index].sharedDataName);
    final String encodedData = SharedAlarm.encode(_sharedDataList);
    await _prefs.setString(_sharedDataList[_index].sharedDataName, encodedData);
  }

  void removeSharedData(int value) {
    _sharedDataList.removeAt(value);
    notifyListeners();
  }
}
