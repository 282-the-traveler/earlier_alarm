import 'package:earlier_alarm/data/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({
    required this.sharedData,
    required this.sharedDataList,
    required this.index,
  });

  SharedData sharedData;
  List<SharedData> sharedDataList = [];
  int index;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  List<bool> selectedWeek = List.generate(
    7,
    (index) => false,
  );


  late TextEditingController _textController =
      TextEditingController(text: widget.sharedData.title);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> setSharedDataList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    SharedData sharedData = SharedData(
      sharedDataName: widget.sharedData.sharedDataName,
      title: widget.sharedData.title,
      time: widget.sharedData.time,
      minusMins: widget.sharedData.minusMins,
      date: widget.sharedData.date,
      // selectedWeek: selectedWeek,
      isOn: widget.sharedData.isOn,
    );

    if (isEdit()) {
      widget.sharedData = sharedData;
    } else {
      widget.sharedDataList.add(sharedData);
    }
    final String encodedData = SharedData.encode(widget.sharedDataList);

    await prefs.setString(widget.sharedData.sharedDataName, encodedData);
    Navigator.pop(context, "save");
  }

  bool isEdit() {
    if (0 <= widget.index && widget.index < 99) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        widget.sharedData.time = result.format(context);
      });
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
            onPressed: () {
              setSharedDataList();
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
                    widget.sharedData.time,
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
                    widget.sharedData.title = text;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.sharedData.date,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  IconButton(
                    onPressed: () {
                      Future<DateTime?> selectedDate = showDatePicker(
                        context: context,
                        initialDate: DateFormat("yyyy-MM-dd")
                            .parse(widget.sharedData.date),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2050),
                      );
                      selectedDate.then((dateTime) {
                        setState(() {
                          widget.sharedData.date =
                              DateFormat('yyyy-MM-dd').format(dateTime!);
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
                  value: widget.sharedData.minusMins,
                  minValue: 0,
                  maxValue: 60,
                  onChanged: (value) =>
                      setState(() => widget.sharedData.minusMins = value),
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
                    widget.sharedData.minusMins.toString(),
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
