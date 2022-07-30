import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({this.name});

  final dynamic name;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  var name = 'alarm';
  var time = '8:30';
  var minusMins = '90';
  var date = '2022-07-29';
  var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  void setTime() {
    SharedData sharedData = SharedData();
    sharedData.setTime(name, time, minusMins, date, week);
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
    return Column(
      children: [
        Expanded(
            child: TextButton(
          onPressed: (){},
          child: const Center(
            child: Text("8:30"),
          ),
        ))
      ],
    );
  }
}
