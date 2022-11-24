import 'dart:async';
import 'dart:math';

import 'package:earlier_alarm/common/layout/default_layout.dart';
import 'package:earlier_alarm/data/my_position.dart';
import 'package:earlier_alarm/providers/position_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentPosition(context);
  }

  void getCurrentPosition(BuildContext context) async {
    MyPosition myPosition = MyPosition();
    await myPosition.getCurrentPosition(context);
  }

  @override
  Widget build(BuildContext context) {
    double latitude = context.read<PositionProvider>().latitude;
    double longitude = context.read<PositionProvider>().longitude;
    // Completer<GoogleMapController> _controller = Completer();
    late GoogleMapController _controller;

    CameraPosition _initialPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15.0,
    );
    final List<Marker> markers = [];

    return DefaultLayout(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (coordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
          int id = Random().nextInt(100);

          setState(() {
            markers.add(Marker(
                position: coordinate, markerId: MarkerId(id.toString())));
          });
        },
        markers: markers.toSet(),
      ),
    );
  }
}
