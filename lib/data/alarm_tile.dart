import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/earlier_alarm.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile(this._sharedData);

  final SharedData _sharedData;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget._sharedData.title,
          style: TextStyle(
            color: Colors.white,
          )),
      title: Text(widget._sharedData.time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 45.0,
          )),
      subtitle: Text(
          'When raining or snowing, alarms' +
              widget._sharedData.minusMins +
              'minutes earlier.',
          style: TextStyle(
            color: Colors.white,
          )),
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddAlarmScreen(
            title: widget._sharedData.title,
            time: widget._sharedData.time,
          );
        }));
      },
    );
  }
}
