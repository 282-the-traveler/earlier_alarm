import 'package:earlier_alarm/data/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen(
      {required this.title,
      required this.time,
      required this.isOn,
      required this.index});

  String title;
  String time;
  bool isOn;
  int index;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  String sharedDataName = 'EARLIER_ALARM';
  SharedData? sampleSharedData;
  int minusMins = 10;
  String date = '2022-07-29';
  bool isData = false;
  final tomorrow = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day + 1,
  );

  List<bool> selectedWeek = List.generate(
    7,
    (index) => false,
  );
  List<SharedData> sharedDataList = [];

  late TextEditingController _textController =
      TextEditingController(text: sampleSharedData!.title);

  @override
  void initState() {
    // TODO: implement initState
    getTime().then((value) => sampleSharedData = value);
    super.initState();
  }

  Future<void> setTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    SharedData sharedData = SharedData(
      sharedDataName: sharedDataName,
      title: widget.title,
      time: widget.time,
      minusMins: minusMins,
      date: date,
      // selectedWeek: selectedWeek,
      isOn: true,
    );

    if (isData) {
      if (widget.index == 99) {
        sharedDataList.add(sharedData);
      } else if (0 <= widget.index && widget.index < 99) {
        sharedDataList[widget.index] = sharedData;
      }
    } else {
      sharedDataList.add(sharedData);
    }
    final String encodedData = SharedData.encode(sharedDataList);

    await prefs.setString(sharedDataName, encodedData);
    Navigator.pop(context);
  }


  bool isEdit() {
    if (0 <= widget.index && widget.index < 99) {
      return true;
    } else {
      return false;
    }
  }


  Future<SharedData> getTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sharedJsonData = prefs.getString(sharedDataName);
    if (sharedJsonData != null) {
      isData = true;
      sharedDataList = SharedData.decode(sharedJsonData!);
      if (isEdit()) {
        print("sharedDataList::::::" + sharedDataList[widget.index].date);
        return sharedDataList[widget.index];
      } else {
        SharedData sharedData = SharedData(
          sharedDataName: sharedDataName,
          title: TimeOfDay.now().format(context),
          time: '',
          minusMins: minusMins,
          date: DateFormat('yyyy-MM-dd').format(tomorrow),
          // selectedWeek: selectedWeek,
          isOn: widget.isOn,
        );
        return sharedData;
      }
    } else {
      SharedData sharedData = SharedData(
        sharedDataName: sharedDataName,
        title: widget.title,
        time: widget.time,
        minusMins: minusMins,
        date: date,
        // selectedWeek: selectedWeek,
        isOn: widget.isOn,
      );
      return sharedData;
    }
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        widget.time = result.format(context);
      });
    }
  }

  // String getTextTime() {
  //   if (!isData) {
  //     return TimeOfDay.now().format(context);
  //   } else {
  //     return widget.time;
  //   }
  // }

  // String getTextTitle() {
  //   if (!isData) {
  //     return '';
  //   } else {
  //     return widget.title;
  //   }
  // }

  // String getTextDate() {
  //   if (!isData) {
  //     date = DateFormat('yyyy-MM-dd').format(tomorrow);
  //   } else {
  //     // getTime().then((value) => date = value.date);
  //   }
  //   return date;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add alarm'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
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
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Time for alarm',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
              ),
              TextButton(
                  onPressed: () {
                    _showTimePicker();
                  },
                  child: Text(
                    sampleSharedData!.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                height: 50.0,
                child: const Text('Title',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
              ),
              TextField(
                cursorColor: Colors.white,
                maxLength: 10,
                controller: _textController,
                obscureText: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
                onChanged: (text) {
                  setState(() {
                    widget.title = text;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Tomorrow ' + sampleSharedData!.date,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  IconButton(
                    onPressed: () {
                      Future<DateTime?> selectedDate = showDatePicker(
                        context: context,
                        initialDate:
                            DateFormat("yyyy-MM-dd").parse(sampleSharedData!.date),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2050),
                      );
                      selectedDate.then((dateTime) {
                        setState(() {
                          date = DateFormat('yyyy-MM-dd').format(dateTime!);
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ToggleButtons(
                color: Colors.white,
                children: const [
                  Text('Sun'),
                  Text('Mon'),
                  Text('Tue'),
                  Text('Wed'),
                  Text('Thur'),
                  Text('Fri'),
                  Text('Sat')
                ],
                onPressed: (int index) {
                  setState(() {
                    selectedWeek[index] = !selectedWeek[index];
                  });
                },
                isSelected: selectedWeek,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 50.0,
                child: const Text('How much earlier?',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                child: NumberPicker(
                  textStyle: (const TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  )),
                  value: minusMins,
                  minValue: 0,
                  maxValue: 60,
                  onChanged: (value) => setState(() => minusMins = value),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('When raining or snowing, alarms ',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  Text(
                    '$minusMins',
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  const Text(' minutes earlier.',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
