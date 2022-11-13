import 'dart:async';
import 'package:earlier_alarm/alarm/add_alarm_screen.dart';
import 'package:earlier_alarm/alarm/alarm_tile.dart';
import 'package:earlier_alarm/alarm/alert_alarm.dart';
import 'package:earlier_alarm/common/datetime_format.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/model/alarm.dart';
import 'package:earlier_alarm/providers/alarm_provider.dart';
import 'package:earlier_alarm/data/weather_conditions.dart';
import 'package:earlier_alarm/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class CurrentAlarmScreen extends StatefulWidget {
  const CurrentAlarmScreen({Key? key}) : super(key: key);

  @override
  State<CurrentAlarmScreen> createState() => _CurrentAlarmScreenState();
}

class _CurrentAlarmScreenState extends State<CurrentAlarmScreen> {
  String sharedDataName = 'EARLIER_ALARM';

  Timer runAlarm(BuildContext context) {
    List<Alarm> alarmList = context.read<AlarmProvider>().alarmList;
    print(alarmList.length);
    return Timer.periodic(
      const Duration(
        minutes: 1,
      ),
      (timer) async {
        List<String> _alarmList = [];
        List<String> _calculatedAlarmList = [];
        for (var alarm in alarmList) {
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
        String _systemTime = DateTimeFormat.getSystemTime();
        if (_calculatedAlarmList.contains(_systemTime)) {
          MyPosition myPosition = MyPosition();
          Map map = await myPosition.getPosition();
          int condition = map['condition'];
          WeatherConditions weatherConditions = WeatherConditions();
          if (weatherConditions.isRainOrSnow(condition)) {
            playAlarm(context);
          }
        } else {
          if (_alarmList.contains(_systemTime)) {
            print(_systemTime);
            playAlarm(context);
          }
        }
      },
    );
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      runAlarm(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.read<AlarmProvider>().alarmList;
  }

  @override
  Widget build(BuildContext context) {
    List<Alarm> sharedDataList = context.read<AlarmProvider>().alarmList;
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
            TimerBuilder.periodic(
              const Duration(
                minutes: 1,
              ),
              builder: (context) {
                return Text(
                  DateTimeFormat.getSystemDateTime(),
                );
              },
            ),
            SvgPicture.asset(
              context.read<WeatherProvider>().weatherImage,
            ),
            Text(
              context.read<WeatherProvider>().temperature.toString() + "\u00B0",
              style: const TextStyle(
                fontSize: 45.0,
              ),
            ),
            const Divider(
              height: 15.0,
              thickness: 2.0,
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddAlarmScreen(
                        alarm: context.read<AlarmProvider>().disposeAlarm(),
                        isEdit: false,
                      );
                    },
                  ),
                ).then((value) => setState(() {}));
              },
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: sharedDataList.length,
                itemBuilder: (context, index) {
                  return AlarmTile(
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
