import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile(this.sharedDataList, this.index);

  List<SharedAlarm> sharedDataList = [];
  int index;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  saveList(List<SharedAlarm> sharedDataList) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    final String encodedData = SharedAlarm.encode(sharedDataList);
    await _prefs.setString(
        sharedDataList[widget.index].sharedDataName, encodedData);
  }

  @override
  Widget build(BuildContext context) {
    Offset _tapPosition = Offset.zero;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapPosition = details.globalPosition;
      },
      child: ListTile(
        leading: Text(
          widget.sharedDataList[widget.index].title,
        ),
        title: Text(widget.sharedDataList[widget.index].time,
            style: const TextStyle(
              fontSize: 30.0,
            )),
        subtitle: Text(
            'When raining or snowing, alarms ' +
                widget.sharedDataList[widget.index].difference.toString() +
                ' minutes earlier.',
            style: const TextStyle()),
        trailing: Switch(
            value: widget.sharedDataList[widget.index].isOn,
            onChanged: (value) {
              setState(() {
                widget.sharedDataList[widget.index].isOn = value;
              });
              saveList(widget.sharedDataList);
            }),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddAlarmScreen(
              sharedDataList: widget.sharedDataList,
              sharedData: widget.sharedDataList[widget.index],
              index: widget.index,
            );
          })).then((value) => setState(() {}));
        },
        onLongPress: () {
          final RenderObject? overlay =
              Overlay.of(context)!.context.findRenderObject();
          showMenu(
              context: context,
              position: RelativeRect.fromRect(_tapPosition & const Size(40, 40),
                  Offset.zero & overlay!.semanticBounds.size),
              items: <PopupMenuEntry>[
                PopupMenuItem(
                    value: widget.index,
                    child: Row(
                      children: const [
                        Text("Delete"),
                        Icon(Icons.close),
                      ],
                    ))
              ]).then((value) => setState(() {
                widget.sharedDataList.removeAt(value);
                saveList(widget.sharedDataList);
              }));
        },
      ),
    );
  }
}
