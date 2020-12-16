import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

import 'UploadScreenWidgets/fine_tune_map.dart';
import 'UploadScreenWidgets/upload_screen_body.dart';
import 'package:solar_streets/Services/latlong_services.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _imageFile;
  Image _image;
  LatLng _panelLocation;

  final picker = ImagePicker();

  Future _getImageAndSetState() async {
    // Take a picture with the camera
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    final bytes = await pickedFile.readAsBytes();
    // Read exif data from image
    final exif = await readExifFromBytes(bytes);
    // Convert day/minute/second coordinates to degrees if exists, else return null
    final lat = gpsDMSToDeg(
        exif["GPS GPSLatitude"].values, exif["GPS GPSLatitudeRef"].printable);
    final long = gpsDMSToDeg(
        exif["GPS GPSLongitude"].values, exif["GPS GPSLongitudeRef"].printable);
    // To see all exif data use the following
    //exif.forEach((key, value) {
    //  print("$key : $value");
    //});

    // Set all the above to state. _panelLocation can be null
    setState(() {
      _imageFile = File(pickedFile.path);
      _image = Image.file(File(pickedFile.path));
      _panelLocation = (lat == null || long == null) ? null : LatLng(lat, long);
    });
  }

  void _regetImage() {
    // Delete temp image file
    if (_imageFile != null) {
      _imageFile.delete();
    }
    // Clear state
    setState(() {
      _image = null;
      _imageFile = null;
      _panelLocation = null;
    });
    // Get image again
    _getImageAndSetState();
  }

  void _fineTuneLocation() async {
    // Open fine tune map screen via navigator
    final LatLng newLocation = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FineTuneMap()));
    // If the back button was pressed (and not the tick) on the FineTuneLocation screen,
    //  no LatLng will be returned. In this case, keep the panelLocation as was
    // Else set it as the returned LatLng
    setState(() {
      _panelLocation = newLocation == null ? _panelLocation : newLocation;
    });
  }

  @override
  void initState() {
    _getImageAndSetState();
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
          backgroundColor: Colors.orange,
        ),
        body: _image != null
            ? UploadBody(
                imageFile: _imageFile,
                panelPosition: _panelLocation,
                fineTuneLocation: _fineTuneLocation)
            : Center(child: CircularProgressIndicator()));
  }
}
