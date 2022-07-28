import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({this.weather, this.temperature, this.weatherImage});

  final dynamic weather;
  final dynamic temperature;
  final dynamic weatherImage;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  int minute = 0;
  String weather = 'Clear';
  int temperature = 25;
  String weatherImage = 'images/sunny.png';

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

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void fetchData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Alarm')),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(onPressed: () {}, child: Text('위치')),
            // Text(position),
            Image(
              image: AssetImage(weatherImage),
              height: 240,
              width: 240,
            ),
            Text('$temperature 도'),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('8:30'),
                    onTap: () {
                      showPickerCustomBuilder(context);
                    },
                  ),
                  ListTile(
                    title: Text('눈, 비 확률 70% 이상 시 $minute분 전에 알람이 울립니다.'),
                    leading: Icon(
                      Icons.umbrella_sharp,
                    ),
                  )
                ],
              ),
            ),
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
