import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWithDraggablePin extends StatefulWidget {
  final Function onSelectedPVPosition;
  const MapWithDraggablePin({
    Key key,
    @required this.onSelectedPVPosition,
  }) : super(key: key);

  @override
  _MapWithDraggablePinState createState() => _MapWithDraggablePinState();
}

class _MapWithDraggablePinState extends State<MapWithDraggablePin> {
  Location location = new Location();
  static LatLng _userLocation;
  static LatLng _userLocationUpperBound;
  static LatLng _userLocationLowerBound;
  LatLng _panelLocation;

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      _userLocation = LatLng(locationData.latitude, locationData.longitude);
      _userLocationUpperBound = LatLng(
          _userLocation.latitude + 0.0007, _userLocation.longitude + 0.0008);
      _userLocationLowerBound = LatLng(
          _userLocation.latitude - 0.0007, _userLocation.longitude - 0.0008);
      _panelLocation = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  _updatePanelLocation(CameraPosition cameraPosition) {
    double lat = cameraPosition.target.latitude;
    double long = cameraPosition.target.longitude;
    setState(() {
      _panelLocation = LatLng(lat, long);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.hybrid,
        minMaxZoomPreference: MinMaxZoomPreference(18, 20),
        cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            southwest: _userLocationLowerBound,
            northeast: _userLocationUpperBound)),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        tiltGesturesEnabled: false,
        trafficEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _panelLocation,
          zoom: 19,
        ),
        markers: Set<Marker>.of(
          <Marker>[
            Marker(
                flat: false,
                markerId: MarkerId('Marker'),
                position: _panelLocation)
          ],
        ),
        onCameraMove: _updatePanelLocation);
  }
}
