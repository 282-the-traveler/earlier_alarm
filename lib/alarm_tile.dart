import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:earlier_alarm/providers/shared_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmTile extends StatefulWidget {
  AlarmTile({Key? key}) : super(key: key);

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  void initState() {
    super.initState();
    getSharedDataList();
  }

  Future<List<SharedAlarm>> getSharedDataList() async {
    List<SharedAlarm> sharedDataList =
        context.read<SharedProvider>().sharedDataList;
    int index = context.read<SharedProvider>().index;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? sharedJsonData =
        _prefs.getString(sharedDataList[index].sharedDataName);
    sharedDataList = SharedAlarm.decode(sharedJsonData!);
    return sharedDataList;
  }

  saveList(List<SharedAlarm> sharedDataList, int index) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(sharedDataList[index].sharedDataName);
    final String encodedData = SharedAlarm.encode(sharedDataList);
    await _prefs.setString(sharedDataList[index].sharedDataName, encodedData);
  }

  @override
  Widget build(BuildContext context) {
    List<SharedAlarm> sharedDataList =
        context.read<SharedProvider>().sharedDataList;
    int index = context.read<SharedProvider>().index;

    Offset _tapPosition = Offset.zero;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapPosition = details.globalPosition;
      },
      child: ListTile(
        leading: Text(
          sharedDataList[index].title,
        ),
        title: Text(sharedDataList[index].time,
            style: const TextStyle(
              fontSize: 30.0,
            )),
        subtitle: Text(
            'When raining or snowing, alarms ' +
                sharedDataList[index].difference.toString() +
                ' minutes earlier.',
            style: const TextStyle()),
        trailing: Switch(
            value: sharedDataList[index].isOn,
            onChanged: (value) {
              setState(() {
                sharedDataList[index].isOn = value;
              });
              saveList(sharedDataList, index);
            }),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddAlarmScreen(
              sharedData: sharedDataList[index],
              index: index,
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
                    value: index,
                    child: Row(
                      children: const [
                        Text("Delete"),
                        Icon(Icons.close),
                      ],
                    ))
              ]).then(
            (value) {
              SharedProvider sharedProvider = Provider.of<SharedProvider>(
                context,
                listen: false,
              );
              sharedProvider.removeSharedData(value);
              sharedProvider.saveList();
              setState(
                () {
                  getSharedDataList();
                },
              );
            },
          );
        },
      ),
    );
  }
}
