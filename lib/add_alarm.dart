import 'package:earlier_alarm/data/datetime_format.dart';
import 'package:earlier_alarm/data/shared_alarm.dart';
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

  SharedAlarm sharedData;
  List<SharedAlarm> sharedDataList = [];
  int index;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  bool _visibility = true;

  late TextEditingController _textController =
      TextEditingController(text: widget.sharedData.title);

  @override
  void initState() {
    _getVisibility();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveList() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    SharedAlarm _sharedData = SharedAlarm(
      sharedDataName: widget.sharedData.sharedDataName,
      title: widget.sharedData.title,
      time: widget.sharedData.time,
      difference: widget.sharedData.difference,
      calculatedTime: widget.sharedData.calculatedTime,
      date: widget.sharedData.date,
      selectedWeek: widget.sharedData.selectedWeek,
      isOn: widget.sharedData.isOn,
    );

    String calculatedTime = DateTimeFormat.getCalculatedTime(
      widget.sharedData.time,
      widget.sharedData.difference,
    );
    _sharedData.calculatedTime = calculatedTime;

    if (_isEdit()) {
      widget.sharedData = _sharedData;
    } else {
      widget.sharedDataList.add(_sharedData);
    }
    final String encodedData = SharedAlarm.encode(widget.sharedDataList);
    _prefs.clear();
    await _prefs.setString(widget.sharedData.sharedDataName, encodedData);
    Navigator.pop(context, "save");
  }

  bool _isEdit() {
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

  void _getVisibility() {
    if (widget.sharedData.selectedWeek.contains(true)) {
      _visibility = false;
    } else {
      _visibility = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add alarm'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _saveList();
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('Time for alarm',
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
            ),
            TextButton(
                onPressed: () {
                  _showTimePicker();
                },
                child: Text(
                  widget.sharedData.time,
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.greenAccent,
                  ),
                )),
            Container(
              alignment: Alignment.centerLeft,
              height: 50.0,
              child: const Text('Title',
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
            ),
            TextField(
              maxLength: 10,
              controller: _textController,
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder()),
              onChanged: (text) {
                setState(() {
                  widget.sharedData.title = text;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  child: Text(widget.sharedData.date, style: const TextStyle()),
                  visible: _visibility,
                ),
                Visibility(
                  child: IconButton(
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
                    ),
                  ),
                  visible: _visibility,
                ),
              ],
            ),
            ToggleButtons(
              children: const [
                Text('Sun'),
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thur'),
                Text('Fri'),
                Text('Sat'),
              ],
              onPressed: (int index) {
                setState(() {
                  widget.sharedData.selectedWeek[index] =
                      !widget.sharedData.selectedWeek[index];
                  _getVisibility();
                });
              },
              isSelected: widget.sharedData.selectedWeek,
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 50.0,
              child: const Text('How much earlier?',
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
            ),
            NumberPicker(
              textStyle: (const TextStyle(
                fontSize: 15.0,
              )),
              value: widget.sharedData.difference,
              minValue: 0,
              maxValue: 60,
              onChanged: (value) =>
                  setState(() => widget.sharedData.difference = value),
            ),
            const Text('When raining or snowing, alarms ', style: TextStyle()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.sharedData.difference.toString(),
                  style: const TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                const Text(
                  ' minutes earlier.',
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
