import 'package:flutter/material.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/data/network.dart';
import 'package:earlier_alarm/current_alarm.dart';

const apikey = '2e61909f3e8052c7fb5f5c84702e9e62';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
  }
  String weather = 'cloudy';
  String weatherImage = 'images/cloudy.png';
  int temperature = 25;

  void getPosition() async {
    MyPosition myPosition = MyPosition();
    await myPosition.getMyCurrentPosition();
    var positionLatitude = myPosition.positionLatitude;
    var positionLongitude = myPosition.positionLongitude;
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$positionLatitude&lon=$positionLongitude&appid=$apikey&units=metric';
    Network network = Network(url);
    var weatherData = await network.getJsonData();
    updateData(weatherData);
  }

  void updateData(dynamic weatherData) {
    weather = weatherData['weather'][0]['main'];
    double doubleTemperature = weatherData['main']['temp'];
    temperature = doubleTemperature.round();
    getWeather(weather);
  }

  void getWeather(var weather) {
    if (weather == 'Clouds') {
      weatherImage = 'svgs/cloudy.svg';
    } else if (weather == 'Clear') {
      weatherImage = 'svgs/day.svg';
    } else if (weather == 'Rain') {
      weatherImage = 'svgs/rainy.svg';
    } else if (weather == 'snowy') {
      weatherImage = 'svgs/snowy.svg';
    }

    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) {
      return CurrentAlarmScreen(
          weather: weather, temperature: temperature, weatherImage: weatherImage,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
