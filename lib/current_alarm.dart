import 'dart:async';
import 'package:earlier_alarm/alert_alarm.dart';
import 'package:earlier_alarm/data/datetime_format.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/data/weather_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/alarm_tile.dart';

class CurrentAlarmScreen extends StatefulWidget {
  CurrentAlarmScreen({this.temperature, this.weatherImage});

  final dynamic temperature;
  final dynamic weatherImage;

  @override
  State<CurrentAlarmScreen> createState() => _CurrentAlarmScreenState();
}

class _CurrentAlarmScreenState extends State<CurrentAlarmScreen> {
  String sharedDataName = 'EARLIER_ALARM';
  List<SharedAlarm> sharedDataList = [];
  List<bool> selectedWeek = List.generate(
    7,
    (index) => false,
  );
  int difference = 30;

  Future<List<SharedAlarm>> getSharedDataList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sharedJsonData = prefs.getString(sharedDataName);
    sharedDataList = SharedAlarm.decode(sharedJsonData!);
    return sharedDataList;
  }

  Timer runAlarm() {
    return Timer.periodic(Duration(minutes: 1), (timer) async {
      List<String> _alarmList = [];
      List<String> _calculatedAlarmList = [];
      sharedDataList.forEach((alarm) {
        if (alarm.isOn) {
          _alarmList.add(alarm.time);
          _calculatedAlarmList.add(alarm.calculatedTime);
        }
      });
      String _currentTime = DateTimeFormat.getSystemTime();
      if (_calculatedAlarmList.contains(_currentTime)) {
        print("_calculatedAlarmList" + _currentTime.toString());
        MyPosition myPosition = MyPosition();
        Map map = await myPosition.getPosition();
        int condition = map['condition'];
        WeatherConditions weatherConditions = WeatherConditions();
        if (weatherConditions.isRainOrSnow(condition)) {
          playAlarm(context);
        }
      } else {
        if (_alarmList.contains(_currentTime)) {
          print("_alarmList" + _currentTime.toString());
          playAlarm(context);
        }
      }
    });
  }

  void playAlarm(BuildContext context) {
    FlutterRingtonePlayer.playAlarm(volume: 5, looping: true, asAlarm: true);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const AlertAlarm();
    }));
  }

  @override
  void initState() {
    setState(() {
      runAlarm();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Image.asset('images/cloudy.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Container(
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
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                }),
                SvgPicture.asset(widget.weatherImage),
                Text(widget.temperature.toString() + "\u00B0",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 45.0,
                    )),
                const Divider(
                  height: 15.0,
                  thickness: 2.0,
                  color: Colors.white30,
                ),
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    SharedAlarm sharedData = SharedAlarm(
                        sharedDataName: 'EARLIER_ALARM',
                        title: '',
                        time: DateTimeFormat.getSystemTime(),
                        difference: difference,
                        calculatedTime: DateTimeFormat.getCalculatedTime(
                            DateTimeFormat.getSystemTime(), difference),
                        date: DateTimeFormat.getTomorrow(),
                        selectedWeek: selectedWeek,
                        isOn: true);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddAlarmScreen(
                        sharedDataList: sharedDataList,
                        sharedData: sharedData,
                        index: 99,
                      );
                    })).then((value) => setState(() {}));
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<SharedAlarm>>(
                    future: getSharedDataList(),
                    builder: (context, snapshot) => ListView.builder(
                      itemCount: sharedDataList.length,
                      itemBuilder: (context, index) {
                        return AlarmTile(sharedDataList, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
