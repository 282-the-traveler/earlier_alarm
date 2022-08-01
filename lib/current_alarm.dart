import 'package:earlier_alarm/add_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  int minute = 0;
  dynamic name = 'noname1';
  dynamic time = '6:30';

  void getTime(String time) {
    SharedData sharedData = SharedData();
    sharedData.getTime(time);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime(this.name);
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
      body: Center(
        child: Stack(
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
                    height: 150.0,
                  ),
                  SvgPicture.asset(widget.weatherImage),
                  TimerBuilder.periodic(Duration(minutes: 1),
                      builder: (context) {
                    return Text(
                      '${getSystemTime()}',
                      style: TextStyle(color: Colors.white),
                    );
                  }),
                  Text(widget.temperature.toString() + "\u00B0",
                      style: TextStyle(color: Colors.white, fontSize: 45.0)),
                  Divider(
                    height: 15.0,
                    thickness: 2.0,
                    color: Colors.white30,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      )),
                  Text(name, style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(time,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 45.0)),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(builder: (context) {
                              return AddAlarmScreen(
                                name: name,
                                time: time,
                              );
                            }));
                          },
                        ),
                        // showPickerCustomBuilder(context);
                        ListTile(
                          title: Text('눈, 비 확률 70% 이상 시 $minute분 전에 알람이 울립니다.',
                              style: TextStyle(color: Colors.white)),
                          leading: Icon(
                            Icons.umbrella_sharp,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
