import 'package:earlier_alarm/data/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:earlier_alarm/data/shared_data.dart';
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
  String id = '9:30 PM-10';
  String title = 'untitled';
  String time = '9:30 PM';
  int minusMins = 10;
  String date = '2022-08-06';
  List<SharedData> sharedDataList = [];

  Future<List<SharedData>> getTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sharedJsonData = prefs.getString(sharedDataName);
    return sharedDataList = SharedData.decode(sharedJsonData!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("HH:mm EEEE, MMM d yyy").format(now);
  }

  String getShortSystemTime() {
    var now = DateTime.now();
    return DateFormat("HH:mm").format(now);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void fetchData() async {}

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
            onPressed: () {
            },
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
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
                TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                  return Text(
                    getSystemTime(),
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddAlarmScreen(
                        title: 'earlier_alarm',
                        time: '24:00 PM',
                        isOn: false,
                        index: 99,
                      );
                    }));
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<SharedData>>(
                    future: getTime(),
                    builder: (context, snapshot) => ListView.builder(
                      itemCount: sharedDataList.length,
                      itemBuilder: (context, index) {
                        return AlarmTile(sharedDataList[index], index);
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
