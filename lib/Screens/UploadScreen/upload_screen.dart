import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';

import 'package:location/location.dart';

import 'UploadScreenWidgets/fine_tune_map.dart';
import 'UploadScreenWidgets/upload_screen_body.dart';
import 'package:bigsolarhunt/Services/dialogue_services.dart';

/// Screen to show when uploading an image. Upon loading the widget the user's
/// default camera app is opened to take an image of a panel. This image, and the
/// user's Latitude and Longitude, are saved to state.
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
  FlutterExif _exif;
  ImagePicker _picker = ImagePicker();

  Location location = new Location();

  Future _getImageAndSetState() async {
    // Take a picture with the camera
    final pickerImage = await _picker.getImage(source: ImageSource.camera);
    Uint8List bytes = await pickerImage.readAsBytes();

    LocationData locationData;

    try {
      locationData = await location.getLocation();
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (_) => new GenericDialogue(
              title: "User location is required to upload images.",
              desc: "Please enable location services for this app.",
              icon: DialogueIcons.ERROR));
      return null;
    }

    if (Platform.isAndroid) {
      // Android-specific code - add location to exif via user location
      _exif = FlutterExif.fromBytes(bytes);
      await _exif.setLatLong(locationData.latitude, locationData.longitude);
      await _exif.saveAttributes();
    }

    // Set all the above to state. _panelLocation can be null
    setState(() {
      _imageFile = File(pickerImage.path);
      _image = Image.file(File(pickerImage.path));
      _panelLocation = LatLng(locationData.latitude, locationData.longitude);
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
    // no LatLng will be returned. In this case, keep the panelLocation as was
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
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            title: Text('Upload a photo',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _regetImage())
            ]),
        body: _image != null
            ? UploadBody(
                imageFile: _imageFile,
                panelPosition: _panelLocation,
                fineTuneLocation: _fineTuneLocation)
            : Center(child: CircularProgressIndicator()));
  }
}
