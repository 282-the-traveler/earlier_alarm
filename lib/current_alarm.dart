import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/alarm_tile.dart';
import 'package:earlier_alarm/data/earlier_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';

class CurrentAlarmScreen extends StatefulWidget {
  CurrentAlarmScreen({this.temperature, this.weatherImage});

  final dynamic temperature;
  final dynamic weatherImage;

  @override
  State<CurrentAlarmScreen> createState() => _CurrentAlarmScreenState();
}

class _CurrentAlarmScreenState extends State<CurrentAlarmScreen> {
  String id = '9:30-10';
  String title = 'noname';
  String time = '9:30';
  String minusMins = '10';
  String date = '20220802';
  List<SharedData> sharedDataList = [];

  Future<List<SharedData>> getTime(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sharedJsonData = await prefs.getString(id);

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
          icon: Icon(Icons.near_me),
          onPressed: () {},
          iconSize: 30.0,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.location_searching),
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
                SizedBox(
                  height: 100.0,
                ),
                TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                  return Text(
                    '${getSystemTime()}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                }),
                SvgPicture.asset(widget.weatherImage),
                Text(widget.temperature.toString() + "\u00B0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45.0,
                    )),
                Divider(
                  height: 15.0,
                  thickness: 2.0,
                  color: Colors.white30,
                ),
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddAlarmScreen(
                        title: title,
                        time: time,
                      );
                    }));
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<SharedData>>(
                    future: getTime(id),
                    builder: (context, snapshot) => ListView.builder(
                        itemCount: sharedDataList.length,
                        itemBuilder: (context, index) {
                          return AlarmTile(sharedDataList[index]);
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
