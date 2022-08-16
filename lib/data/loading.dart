import 'package:earlier_alarm/weather.dart';
import 'package:flutter/material.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/data/network.dart';
import 'package:earlier_alarm/current_alarm.dart';
import 'weather_conditions.dart';

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
    getPosition();
    super.initState();
  }

  dynamic weatherImage = 'svgs/day.svg';
  int temperature = 25;
  WeatherConditions weatherConditions = WeatherConditions();

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
    int condition = weatherData['weather'][0]['id'];
    double doubleTemperature = weatherData['main']['temp'];
    temperature = doubleTemperature.round();
    int sunrise = weatherData['sys']['sunrise'];
    int sunset = weatherData['sys']['sunset'];
    weatherImage =
        weatherConditions.getWeatherImage(condition, sunrise, sunset);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CurrentAlarmScreen(
        temperature: temperature,
        weatherImage: weatherImage,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200.0,
      width: 200.0,
      child: CircularProgressIndicator(),
    );
  }
}
