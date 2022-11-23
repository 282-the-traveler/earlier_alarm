import 'package:flutter/material.dart';

class PositionProvider extends ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;

  double get latitude => _latitude;

  double get longitude => _longitude;

  void setLatitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  void setLongitude(double value) {
    _longitude = value;
    notifyListeners();
  }
}
