import 'package:geolocator/geolocator.dart';

import 'network.dart';

const apikey = '2e61909f3e8052c7fb5f5c84702e9e62';

class MyPosition {
  double positionLatitude = 0.0;
  double positionLongitude = 0.0;

  Future<Map> getPosition() async {
    await getMyCurrentPosition();
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$positionLatitude&lon=$positionLongitude&appid=$apikey&units=metric';
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

  Future<void> getMyCurrentPosition() async {
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

        positionLatitude = position.latitude;
        positionLongitude = position.longitude;
      }
    } catch (e) {
      print('There\'s a problem with internet connection');
    }
  }
}
