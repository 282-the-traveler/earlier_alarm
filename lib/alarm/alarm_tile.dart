import 'package:earlier_alarm/alarm/add_alarm_screen.dart';
import 'package:earlier_alarm/providers/alarm_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AlarmProvider>().alarmList;
  }

  @override
  Widget build(BuildContext context) {
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(
      context,
      listen: false,
    );

    Offset _tapPosition = Offset.zero;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapPosition = details.globalPosition;
      },
      child: ListTile(
        leading: Text(
          alarmProvider.alarmList[widget.index].title,
        ),
        title: Text(alarmProvider.alarmList[widget.index].time,
            style: const TextStyle(
              fontSize: 30.0,
            )),
        subtitle: Text(
            'When raining or snowing, alarms ' +
                alarmProvider.alarmList[widget.index].difference.toString() +
                ' minutes earlier.',
            style: const TextStyle()),
        trailing: Switch(
            value: alarmProvider.alarmList[widget.index].isOn,
            onChanged: (value) {
              setState(() {
                alarmProvider.alarmList[widget.index].isOn = value;
              });
              alarmProvider.setAlarmDataList(alarmProvider.alarmList);
            }),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddAlarmScreen(
              alarm: alarmProvider.alarmList[widget.index],
              isEdit: true,
            );
          })).then((value) => setState(() {}));
        },
        onLongPress: () {
          final RenderObject? overlay =
              Overlay.of(context)!.context.findRenderObject();
          showMenu(
              context: context,
              position: RelativeRect.fromRect(
                  _tapPosition &
                      const Size(
                        40,
                        40,
                      ),
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
              ]).then(
            (value) {
              alarmProvider.removeAlarm(value);
              alarmProvider.setAlarmDataList(alarmProvider.alarmList);
              setState(() {
                context.read<AlarmProvider>().alarmList;
              });
            },
          );
        },
      ),
    );
  }
}
