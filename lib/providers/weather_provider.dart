import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  int _temperature =0;
  String _weatherImage ='';

  int get temperature => _temperature;
  String get weatherImage => _weatherImage;

  void setTemperature(int value) {
    _temperature = value;
    notifyListeners();
  }

  void setWeatherImage(String value) {
    _weatherImage = value;
    notifyListeners();
  }
}