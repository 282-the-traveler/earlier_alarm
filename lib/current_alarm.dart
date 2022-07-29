import 'package:earlier_alarm/add_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class CurrentAlarmScreen extends StatefulWidget {
  CurrentAlarmScreen({this.weather, this.temperature, this.weatherImage});

  final dynamic weather;
  final dynamic temperature;
  final dynamic weatherImage;

  @override
  State<CurrentAlarmScreen> createState() => _CurrentAlarmScreenState();
}

class _CurrentAlarmScreenState extends State<CurrentAlarmScreen> {
  int minute = 0;
  String weather = 'Clear';
  int temperature = 25;
  String weatherImage = 'svgs/Sun.svg';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.weather, widget.temperature, widget.weatherImage);
  }

  void updateData(dynamic weather, dynamic temperature, dynamic weatherImage) {
    this.weather = weather;
    this.temperature = temperature;
    this.weatherImage = weatherImage;
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("HH:mm EEEE, MMM d yyy").format(now);
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
                  SvgPicture.asset(weatherImage),
                  TimerBuilder.periodic(Duration(minutes: 1),
                      builder: (context) {
                    return Text(
                      '${getSystemTime()}',
                      style: TextStyle(color: Colors.white),
                    );
                  }),
                  Text('$temperature\u2103',
                      style: TextStyle(color: Colors.white, fontSize: 30.0)),
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
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('8:30',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 45.0)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddAlarmScreen();
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

showPickerCustomBuilder(BuildContext context) {
  Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(
        customColumnType: [3, 4],
      ),
      title: Text("시간을 선택하세요"),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onBuilderItem: (context, text, child, selected, col, index) {
        if (col == 0 || selected) return null;
        return Text(text ?? '',
            style: TextStyle(
              color: Colors.green,
            ));
      },
      onConfirm: (Picker picker, List value) {
        print((picker.adapter as DateTimePickerAdapter).value);
      }).showDialog(context);
}
