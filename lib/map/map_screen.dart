import 'dart:async';

import 'package:earlier_alarm/common/layout/default_layout.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Completer<GoogleMapController> _controller = Completer();
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
    // void getLatLng(BuildContext context) async {
    //   MyPosition myPosition = MyPosition();
    //   Map map = await myPosition.getMyCurrentPosition();
    // }
    return DefaultLayout(
      child: GoogleMap(
        mapType: MapType.hybrid, initialCameraPosition: _kGooglePlex,

      ),
    );
  }
}
