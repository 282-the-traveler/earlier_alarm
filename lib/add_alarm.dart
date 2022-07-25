import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/data/network.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({Key? key}) : super(key: key);

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  int minute = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void getPosition() async {
    MyPosition myPosition = MyPosition();
    await myPosition.getMyCurrentPosition();
    Network network = Network('https://samples.openweathermap.org/data/2.5/weather?q=London&&appid=b6907d289e10d714a6e88b30761fae22');

    var weatherData = await network.getJsonData();
    print (weatherData);
  }

  void fetchData() async {
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Alarm')),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  getPosition();
                },
                child: Text('위치')),
            // Text(position),
            Image(
              image: AssetImage('images/rain.png'),
              height: 240,
              width: 240,
            ),
            Text('24도 C'),
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
                    title: Text('확률 70% 이상 시 $minute분 전에 알람이 울립니다.'),
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
