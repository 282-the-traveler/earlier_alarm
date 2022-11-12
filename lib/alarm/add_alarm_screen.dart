import 'package:earlier_alarm/common/datetime_format.dart';
import 'package:earlier_alarm/model/shared_alarm.dart';
import 'package:earlier_alarm/providers/shared_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({
    required this.sharedData,
    required this.isEdit,
  });

  SharedAlarm sharedData;
  bool isEdit;

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
    context.read<SharedProvider>().disposeSharedData();
    super.dispose();
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    print (result.toString());
    print (widget.sharedData.time);
    if (result != null) {
      setState(() {
        widget.sharedData.time = result.format(context);
        print (widget.sharedData.time);
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
    SharedProvider sharedProvider = Provider.of<SharedProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add alarm'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              String calculatedTime = DateTimeFormat.getCalculatedTime(
                widget.sharedData.time,
                widget.sharedData.difference,
              );
              widget.sharedData.calculatedTime = calculatedTime;

              if (widget.isEdit) {
                sharedProvider.setSharedAlarm(widget.sharedData);
              } else {
                sharedProvider.addSharedData(widget.sharedData);
              }
              Navigator.pop(context, "save");
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
