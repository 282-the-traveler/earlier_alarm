import 'package:earlier_alarm/common/datetime_format.dart';
import 'package:earlier_alarm/model/shared_alarm.dart';
import 'package:flutter/material.dart';

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
  bool _isOn = true;

  List<SharedAlarm> get sharedDataList => _sharedDataList;

  int get index => _index;

  SharedAlarm get sharedAlarm => _sharedAlarm;

  bool get isOn => _isOn;

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

  SharedAlarm disposeSharedData() {
    _sharedAlarm = SharedAlarm(
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
    return _sharedAlarm;
  }

  void setIsOn(bool value) {
    _sharedDataList[_index].isOn = value;
    notifyListeners();
  }

  void removeSharedData(int value) {
    _sharedDataList.removeAt(value);
    notifyListeners();
  }
}
