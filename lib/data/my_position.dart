import 'package:earlier_alarm/providers/position_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../common/network.dart';

const apikey = '2e61909f3e8052c7fb5f5c84702e9e62';

class MyPosition {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getCurrentPosition(BuildContext context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        latitude = position.latitude;
        longitude = position.longitude;
        PositionProvider positionProvider = Provider.of<PositionProvider>(
          context,
          listen: false,
        );
        positionProvider.setLatitude(latitude);
        positionProvider.setLongitude(longitude);
      }
    } catch (e) {
      print('There\'s a problem with internet connection');
    }
  }

  Future<Map> getWeatherCondition(BuildContext context) async {
    await getCurrentPosition(context);
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey&units=metric';
    Network network = Network(url);
    var weatherData = await network.getJsonData();
    int condition = weatherData['weather'][0]['id'];
    double doubleTemperature = weatherData['main']['temp'];
    int temperature = doubleTemperature.round();
    int sunrise = weatherData['sys']['sunrise'];
    int sunset = weatherData['sys']['sunset'];
    Map<String, int> weatherMap = {
      'condition': condition,
      'temperature': temperature,
      'sunrise': sunrise,
      'sunset': sunset
    };
    return weatherMap;
  }
}
