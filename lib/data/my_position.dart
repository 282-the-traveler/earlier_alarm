import 'package:geolocator/geolocator.dart';

class MyPosition {
  double latitude2 = 0.0;
  double longitude2 = 0.0;

  Future<void> getMyCurrentPosition() async{
  // LocationPermission locationPermission = await Geolocator
  //     .requestPermission();
  try {
  // Position position = await Geolocator.getCurrentPosition(
  // desiredAccuracy: LocationAccuracy.high);

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
    }


    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);


  latitude2 = position.latitude;
  longitude2 = position.longitude;
  print(longitude2);
  } catch(e){
  print('There\'s a problem with internet connection');
  }
}
}