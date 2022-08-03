import 'package:earlier_alarm/data/earlier_alarm.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  AlarmTile(this._sharedData);

  final SharedData _sharedData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.umbrella),
      title: Text(_sharedData.time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 45.0,
          )),
      subtitle: Text(
          'When raining or snowing, alarms' +
              _sharedData.minusMins +
              'minutes earlier.',
          style: TextStyle(
            color: Colors.white,
          )),
      trailing: Text(_sharedData.title,
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }
}
