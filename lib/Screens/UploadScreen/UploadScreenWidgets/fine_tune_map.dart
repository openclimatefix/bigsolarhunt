import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FineTuneMap extends StatefulWidget {
  const FineTuneMap({Key key}) : super(key: key);

  @override
  _FineTuneMapState createState() => _FineTuneMapState();
}

class _FineTuneMapState extends State<FineTuneMap> {
  Location location = new Location();
  static LatLng _userLocation;
  static LatLng _userLocationUpperBound;
  static LatLng _userLocationLowerBound;
  static LatLng _panelLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    if (!mounted) return;
    setState(() {
      _userLocation = LatLng(locationData.latitude, locationData.longitude);
      _panelLocation = LatLng(locationData.latitude, locationData.longitude);
      _userLocationUpperBound = LatLng(
          locationData.latitude + 0.0007, locationData.longitude + 0.0008);
      _userLocationLowerBound = LatLng(
          locationData.latitude - 0.0007, locationData.longitude - 0.0008);
    });
  }

  _updatePanelLocation(CameraPosition cameraPosition) {
    // Set the panel location to the camera's target
    double lat = cameraPosition.target.latitude;
    double long = cameraPosition.target.longitude;
    setState(() {
      _panelLocation = LatLng(lat, long);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit location',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.done),
                onPressed: () => Navigator.pop(context, _panelLocation))
          ],
          backgroundColor: Colors.deepOrange,
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
              mapType: MapType.hybrid,
              minMaxZoomPreference: MinMaxZoomPreference(18, 20),
              cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                  southwest: _userLocationLowerBound,
                  northeast: _userLocationUpperBound)),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              trafficEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _userLocation,
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
              onCameraMove: _updatePanelLocation),
          Container(
              padding: EdgeInsets.only(bottom: 70),
              alignment: Alignment.bottomCenter,
              child: Text("Drag the map to position the marker",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center))
        ]));
  }
}
