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
        title: Text('Upload a photo', style: Theme.of(context).textTheme.headline4),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: () => _regetImage())
        ],
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
          child: Stack(children: <Widget>[
        Container(
            // TODO: Map goes here
            color: Colors.blue,
            child: MapWithDraggablePin()),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: ImageCard(image: _image)),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: UploadButton(image: _image)),
        Center(
          child: Icon(
            Icons.control_point_duplicate,
            color: Colors.white,
            size: 50,
          ),
        )
      ])),
    );
  }
}

class MapWithDraggablePin extends StatefulWidget {
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

  _onCameraIdle() async {
    _
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.satellite,
      minMaxZoomPreference: MinMaxZoomPreference(18, 20),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _markerLocation,
        zoom: 19,
      ),
      markers: Set<Marker>.of(
        <Marker>[
          Marker(
              onTap: () {
                print('Tapped');
              },
              draggable: true,
              markerId: MarkerId('Marker'),
              position: _markerLocation,
              onDragEnd: ((value) {
                print(value.latitude);
                print(value.longitude);
              }))
        ],
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      onCameraIdle: () => print(_mapController.getLatLng())),
    );
  }
}
