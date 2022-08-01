import 'package:geolocator/geolocator.dart';

class MyPosition {
  double positionLatitude = 0.0;
  double positionLongitude = 0.0;

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
        print(position);

        positionLatitude = position.latitude;
        positionLongitude = position.longitude;
      }
    } catch (e) {
      print('There\'s a problem with internet connection');
    }
  }
}
