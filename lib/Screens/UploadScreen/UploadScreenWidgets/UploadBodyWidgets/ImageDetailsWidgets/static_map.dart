import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticMap extends StatelessWidget {
  final LatLng panelPosition;

  const StaticMap({
    Key key,
    @required this.panelPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        tiltGesturesEnabled: false,
        trafficEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        liteModeEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        initialCameraPosition: CameraPosition(
          target: panelPosition,
          zoom: 17,
        ),
        markers: Set<Marker>.of(
          <Marker>[
            Marker(
                flat: false,
                markerId: MarkerId('Marker'),
                position: panelPosition)
          ],
        ));
  }
}
