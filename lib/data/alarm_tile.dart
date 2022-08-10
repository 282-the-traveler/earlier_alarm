import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/shared_data.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile(this._sharedData, this.index);

  final SharedData _sharedData;
  int index;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget._sharedData.title,
          style: const TextStyle(
            color: Colors.white,
          )),
      title: Text(widget._sharedData.time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 45.0,
          )),
      subtitle: Text(
          'When raining or snowing, alarms ' + widget._sharedData.minusMins.toString() + ' minutes earlier.',
          style: const TextStyle(
            color: Colors.white,
          )),
      trailing: Switch(
        value: isOn,
        onChanged: (value) {
          setState(() {
            isOn = value;
          });
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddAlarmScreen(
            title: widget._sharedData.title,
            time: widget._sharedData.time,
            isOn: isOn,
            index: widget.index,
          );
        }));
      },
      onLongPress: () {},
    );
  }
}
