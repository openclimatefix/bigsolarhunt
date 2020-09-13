import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'UploadScreenWidgets/upload_button.dart';
import 'UploadScreenWidgets/image_card.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  Location location = new Location();
  static LatLng _userLocation;
  static LatLng _userLocationUpperBound;
  static LatLng _userLocationLowerBound;
  LatLng _panelLocation;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      print(_image);
    });
  }

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

  void _regetImage() {
    _image.delete();
    setState(() {
      _image = null;
    });
    _getImage();
  }

  @override
  void initState() {
    _getImage().then((value) {
      print('Got async image');
    });
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a photo'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: () => _regetImage())
        ],
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[100],
      body: Container(
          child: Stack(children: <Widget>[
        Container(
            child: GoogleMap(
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
                onCameraMove: _updatePanelLocation)),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: ImageCard(image: _image)),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: UploadButton(
              image: _image,
              panelLocation: _panelLocation,
            ))
      ])),
    );
  }
}
