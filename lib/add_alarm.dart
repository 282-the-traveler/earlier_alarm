import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/data/network.dart';

const apikey = '2e61909f3e8052c7fb5f5c84702e9e62';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({Key? key}) : super(key: key);

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  int minute = 0;

  String weather = 'cloudy';
  String weatherImage = 'images/cloudy.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
    getWeather();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void getWeather() {
    if (weather == 'cloudy') {
      weatherImage = 'images/cloudy.png';
    } else if (weather == 'sunny') {
      weatherImage = 'images/sunny.png';
    } else if (weather == 'rainy') {
      weatherImage = 'image/rainy.png';
    } else if (weather == 'snowy') {
      weatherImage = 'image/snowy.png';
    }
  }

  void getPosition() async {
    MyPosition myPosition = MyPosition();
    await myPosition.getMyCurrentPosition();
    var positionLatitude = myPosition.positionLatitude;
    var positionLongitude = myPosition.positionLongitude;
    var url = 'https://api.openweathermap.org/data/2.5/weather?lat=$positionLatitude&lon=$positionLongitude&appid=$apikey';
    Network network = Network(url);

    print("url:::" + url);
    var weatherData = await network.getJsonData();
    print("weatherData:::" + weatherData);
  }

  void fetchData() async {}

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
              image: AssetImage(weatherImage),
              height: 240,
              width: 240,
            ),
            Text('24도'),
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
