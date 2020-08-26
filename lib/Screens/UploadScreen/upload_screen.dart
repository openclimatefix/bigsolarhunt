import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      print(_image);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a photo',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: () => _regetImage())
        ],
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
          child: Stack(children: <Widget>[
        Container(
            child: MapWithDraggablePin(
                onSelectedPVPosition: () => {})), //TODO: upload callback
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: ImageCard(image: _image)),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: UploadButton(image: _image))
      ])),
    );
  }
}

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
  GoogleMapController _mapController;
  static LatLng _markerLocation;

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      _markerLocation = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  _updateMarkerLocation(CameraPosition cameraPosition) {
    double lat = cameraPosition.target.latitude;
    double long = cameraPosition.target.longitude;
    setState(() {
      _markerLocation = LatLng(lat, long);
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
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        tiltGesturesEnabled: false,
        trafficEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _markerLocation,
          zoom: 19,
        ),
        markers: Set<Marker>.of(
          <Marker>[
            Marker(
                flat: false,
                markerId: MarkerId('Marker'),
                position: _markerLocation)
          ],
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onCameraMove: _updateMarkerLocation);
  }
}
