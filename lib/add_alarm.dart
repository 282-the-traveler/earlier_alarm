import 'package:earlier_alarm/data/shared_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({this.title, this.time});

  final dynamic title;
  final dynamic time;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  var id = '9:30\-10';
  var title = 'untitled';
  var time = '9:30';
  var minusMins = '10';
  var date = '2022-07-29';
  var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  TextEditingController _textController = TextEditingController();

  String inputText = 'noname';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTime();
  }

  Future<void> setTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = SharedData.encode([
      SharedData(id: id, title: title, time: time, minusMins: minusMins, date: date)
    ]);

    await prefs.setString(id, encodedData);
    print(encodedData);
    // await prefs.setStringList('name', 'time', 'minus', 'date',
    //     <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat']);
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
      body:
        Stack(
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
                TextField(
                  controller: _textController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Title',
                  ),
                  onChanged: (text) {
                    setState(() {
                      inputText = text;
                    });
                  },
                )
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
