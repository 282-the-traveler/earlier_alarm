import 'package:earlier_alarm/data/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen(
      {this.title, this.time, required this.isOn, required this.index});

  dynamic title;
  dynamic time;
  bool isOn;
  int index;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  String sharedDataName = 'EARLIER_ALARM';
  var id = '9:30 PM\-10';
  var minusMins = '10';
  var date = '2022-07-29';
  var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};
  List<SharedData> sharedDataList = [];
  late TextEditingController _textController =
      TextEditingController(text: getTextTitle());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> setTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = widget.time + '\-' + minusMins;

    final String? sharedJsonData = prefs.getString(sharedDataName);
    sharedDataList = SharedData.decode(sharedJsonData!);

    if (sharedJsonData != null) {
      print(sharedJsonData);
      sharedDataList[widget.index] = SharedData(
        sharedDataName: sharedDataName,
        id: id,
        title: widget.title,
        time: widget.time,
        minusMins: minusMins,
        date: date,
        isOn: widget.isOn,
      );
    } else {
      sharedDataList.add(SharedData(
        sharedDataName: sharedDataName,
        id: id,
        title: widget.title,
        time: widget.time,
        minusMins: minusMins,
        date: date,
        isOn: widget.isOn,
      ));
    }

    final String encodedData = SharedData.encode(sharedDataList);

    await prefs.setString(sharedDataName, encodedData);
    // await prefs.setStringList('name', 'time', 'minus', 'date',
    //     <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat']);
    Navigator.pop(context);
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: getTextTime(),
    );
    if (result != null) {
      setState(() {
        widget.time = result.format(context);
      });
    }
  }

  dynamic getTextTime() {
    if (widget.time == '24:00 PM') {
      return TimeOfDay.now();
      print('24:00 PM');
    } else {
      return widget.time;
      print('04:51 PM');
    }
  }

  String getTextTitle() {
    if (widget.title == 'earlier_alarm') {
      return '';
    } else {
      return widget.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add alarm'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            // textColor: Colors.white,
            onPressed: () {
              // **sharedpreference에 담기
              setTime();
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset('images/cloudy.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
              TextButton(
                  onPressed: () {
                    _showTimePicker();
                  },
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  )),
              TextField(
                cursorColor: Colors.white,
                maxLength: 10,
                controller: _textController,
                obscureText: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                  helperStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )
                ),
                onChanged: (text) {
                  setState(() {
                    widget.title = text;
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    _showTimePicker();
                  },
                  child: Text(
                    minusMins,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
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
      ),
    );
  }
}
