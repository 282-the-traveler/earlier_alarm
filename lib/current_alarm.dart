import 'dart:async';
import 'package:earlier_alarm/alert_alarm.dart';
import 'package:earlier_alarm/data/datetime_format.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/providers/shared_provider.dart';
import 'package:earlier_alarm/data/weather_conditions.dart';
import 'package:earlier_alarm/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/alarm_tile.dart';

class CurrentAlarmScreen extends StatefulWidget {
  CurrentAlarmScreen();

  @override
  State<CurrentAlarmScreen> createState() => _CurrentAlarmScreenState();
}

class _CurrentAlarmScreenState extends State<CurrentAlarmScreen> {
  String sharedDataName = 'EARLIER_ALARM';

  Future<List<SharedAlarm>> getSharedDataList(BuildContext context) async {
    List<SharedAlarm> sharedDataList =
        context.read<SharedProvider>().sharedDataList;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? sharedJsonData = _prefs.getString(sharedDataName);
    sharedDataList = SharedAlarm.decode(sharedJsonData!);
    SharedProvider sharedProvider = Provider.of<SharedProvider>(
      context,
      listen: false,
    );
    sharedProvider.setSharedDataList(sharedDataList);
    return sharedDataList;
  }

  Timer runAlarm(BuildContext context) {
    List<SharedAlarm> sharedDataList =
        context.read<SharedProvider>().sharedDataList;
    return Timer.periodic(
        Duration(
          minutes: 1,
        ), (timer) async {
      List<String> _alarmList = [];
      List<String> _calculatedAlarmList = [];
      for (var alarm in sharedDataList) {
        if (alarm.isOn) {
          if (alarm.date.contains(DateTimeFormat.getToday()) &&
              !DateTimeFormat.isContain(alarm.selectedWeek)) {
            _alarmList.add(alarm.time);
            _calculatedAlarmList.add(alarm.calculatedTime);
          } else {
            if (DateTimeFormat.getWeekday(alarm.selectedWeek)) {
              _alarmList.add(alarm.time);
              _calculatedAlarmList.add(alarm.calculatedTime);
            }
          }
        }
      }
      String _currentTime = DateTimeFormat.getSystemTime();
      if (_calculatedAlarmList.contains(_currentTime)) {
        MyPosition myPosition = MyPosition();
        Map map = await myPosition.getPosition();
        int condition = map['condition'];
        WeatherConditions weatherConditions = WeatherConditions();
        if (weatherConditions.isRainOrSnow(condition)) {
          playAlarm(context);
        }
      } else {
        if (_alarmList.contains(_currentTime)) {
          playAlarm(context);
        }
      }
    });
  }

  void playAlarm(BuildContext context) {
    FlutterRingtonePlayer.playAlarm(
      volume: 5,
      looping: true,
      asAlarm: true,
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const AlertAlarm();
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    runAlarm(context);
    getSharedDataList(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Widget build(BuildContext context) {
    List<SharedAlarm> sharedDataList =
        context.read<SharedProvider>().sharedDataList;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.near_me),
          onPressed: () {},
          iconSize: 30.0,
          color: Colors.transparent,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_searching),
            iconSize: 30.0,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 100.0,
            ),
            TimerBuilder.periodic(const Duration(minutes: 1),
                builder: (context) {
              return Text(
                DateTimeFormat.getSystemDateTime(),
              );
            }),
            SvgPicture.asset(
              context.read<WeatherProvider>().weatherImage,
            ),
            Text(
                context.read<WeatherProvider>().temperature.toString() +
                    "\u00B0",
                style: const TextStyle(
                  fontSize: 45.0,
                )),
            const Divider(
              height: 15.0,
              thickness: 2.0,
            ),
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddAlarmScreen(
                    sharedData: context.read<SharedProvider>().sharedAlarm,
                    index: 99,
                  );
                })).then((value) => setState(() {}));
              },
            ),
            Expanded(
              child: FutureBuilder<List<SharedAlarm>>(
                future: getSharedDataList(context),
                builder: (context, snapshot) => ListView.builder(
                  itemCount: sharedDataList.length,
                  itemBuilder: (context, index) {
                    SharedProvider sharedProvider = Provider.of<SharedProvider>(
                      context,
                      listen: false,
                    );
                    sharedProvider.setIndex(index);
                    return AlarmTile();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
