import 'package:collection/collection.dart';
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
  final List<Marker> _markers = [];
  double latitude = 0.0;
  double longitude = 0.0;
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    getCurrentPosition(context);
    latitude = context.read<PositionProvider>().latitude;
    longitude = context.read<PositionProvider>().longitude;
    _markers.add(Marker(
        markerId: const MarkerId("current_position"),
        draggable: true,
        position: LatLng(latitude, longitude)));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _updatePosition(CameraPosition _position) {
    latitude = _position.target.latitude;
    longitude = _position.target.longitude;
    var m = _markers.firstWhereOrNull(
      (p) => p.markerId == const MarkerId('current_position'),
    );
    _markers.remove(m);
    _markers.add(
      Marker(
        markerId: const MarkerId('current_position'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
      ),
    );
    setState(() {});
  }

  void getCurrentPosition(BuildContext context) async {
    MyPosition myPosition = MyPosition();
    await myPosition.getCurrentPosition(context);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15.0,
    );

    return DefaultLayout(
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },
            onTap: (coordinate) {
              _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
            },
            markers: _markers.toSet(),
            onCameraMove: ((_position) => _updatePosition(_position)),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.0,
            right: 10.0,
            child: TextButton(
              onPressed: () {
                PositionProvider positionProvider =
                    Provider.of<PositionProvider>(
                  context,
                  listen: false,
                );
                positionProvider.setLatitude(latitude);
                positionProvider.setLongitude(longitude);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
