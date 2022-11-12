import 'package:earlier_alarm/alarm/add_alarm_screen.dart';
import 'package:earlier_alarm/providers/shared_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile({required this.index});

  int index;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SharedProvider>().sharedDataList;
  }

  @override
  Widget build(BuildContext context) {
    SharedProvider sharedProvider = Provider.of<SharedProvider>(
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
          sharedProvider.sharedDataList[widget.index].title,
        ),
        title: Text(sharedProvider.sharedDataList[widget.index].time,
            style: const TextStyle(
              fontSize: 30.0,
            )),
        subtitle: Text(
            'When raining or snowing, alarms ' +
                sharedProvider.sharedDataList[widget.index].difference
                    .toString() +
                ' minutes earlier.',
            style: const TextStyle()),
        trailing: Switch(
            value: sharedProvider.sharedDataList[widget.index].isOn,
            onChanged: (value) {
              setState(() {
                sharedProvider.sharedDataList[widget.index].isOn = value;
              });
              sharedProvider.setSharedDataList(sharedProvider.sharedDataList);
            }),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddAlarmScreen(
              sharedData: sharedProvider.sharedDataList[widget.index],
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
              sharedProvider.removeSharedData(value);
              sharedProvider.setSharedDataList(sharedProvider.sharedDataList);
              setState(
                () {
                  context.read<SharedProvider>().sharedDataList;
                },
              );
            },
          );
        },
      ),
    );
  }
}
