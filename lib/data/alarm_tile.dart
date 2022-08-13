import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/shared_data.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile(this.sharedDataList, this.index);

  List<SharedData> sharedDataList = [];
  int index;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget.sharedDataList[widget.index].title,
          style: const TextStyle(
            color: Colors.white,
          )),
      title: Text(widget.sharedDataList[widget.index].time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 45.0,
          )),
      subtitle: Text(
          'When raining or snowing, alarms ' + widget.sharedDataList[widget.index].minusMins.toString() + ' minutes earlier.',
          style: const TextStyle(
            color: Colors.white,
          )),
      trailing: Switch(
        value: widget.sharedDataList[widget.index].isOn,
        onChanged: (value) {
          setState(() {
            widget.sharedDataList[widget.index].isOn = value;
          });
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddAlarmScreen(
            sharedDataList: widget.sharedDataList,
            sharedData: widget.sharedDataList[widget.index],
            index: widget.index,
          );
        }));
      },
      onLongPress: () {},
    );
  }
}
