import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({this.name, this.time});

  final dynamic name;
  final dynamic time;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  var minusMins = '90';
  var date = '2022-07-29';
  var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTime();
  }

  void setTime() {
    SharedData sharedData = SharedData();
    sharedData.setTime(widget.name, widget.time, minusMins, date, week);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('images/cloudy.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        Container(
          child: Column(children: [
            TextButton(
                onPressed: () {
                  showPickerCustomBuilder;
                },
                child: Text(
                  widget.time,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                )),
            TextButton(
                onPressed: () {},
                child: Text(
                  widget.name,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                )),
          ]),
        )
      ],
      // Row(
      //   children: [
      //     ListView(
      //       children: [
      //         ListTile(
      //           title: Text('Sun'),
      //         ),
      //         ListTile(
      //           title: Text('Mon'),
      //         ),
      //         ListTile(
      //           title: Text('Tue'),
      //         ),
      //         ListTile(
      //           title: Text('Wed'),
      //         ),
      //         ListTile(
      //           title: Text('Thur'),
      //         ),
      //         ListTile(
      //           title: Text('Fri'),
      //         ),
      //         ListTile(
      //           title: Text('Sat'),
      //         )
      //       ],
      //     )
      //   ],
      // )
    );
  }
}
