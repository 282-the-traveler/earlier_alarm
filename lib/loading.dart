import 'package:flutter/material.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/current_alarm.dart';
import 'data/weather_conditions.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    getWeather(context);
    super.initState();
  }

  void getWeather(BuildContext context) async {
    MyPosition myPosition = MyPosition();
    Map map = await myPosition.getPosition();
    int condition = map['condition'];
    int temperature = map['temperature'];
    int sunrise = map['sunrise'];
    int sunset = map['sunset'];
    WeatherConditions weatherConditions = WeatherConditions();
    String weatherImage =
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
