import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:solar_streets/Services/mapillary_service.dart';
import 'upload_dialogues.dart';

class UploadButton extends StatefulWidget {
  // Dynamic button able to upload a File to OSM and display status
  //  of the async OSM API calls
  final File image;
  final LatLng panelLocation;
  const UploadButton({Key key, this.image, this.panelLocation})
      : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  MapillaryService mapillaryService = new MapillaryService();
  ButtonState state = ButtonState.idle;

  void handleUpload(image, panelLocation) async {
    _displayLoading();
    var responseImage;
    try {
      responseImage = await mapillaryService.upload(image, panelLocation);
    } catch (e) {
      _displayFailure();
      print(e);
      showDialog(
          context: context, builder: (_) => new UploadFailedDialogue(error: e));
      return null;
    }
    _displaySuccess();
    showDialog(context: context, builder: (_) => new UploadCompleteDialogue());
    return responseImage;
  }

  void _displayLoading() {
    setState(() {
      state = ButtonState.loading;
    });
  }

  void _displaySuccess() {
    setState(() {
      state = ButtonState.success;
    });
  }

  void _displayFailure() {
    setState(() {
      state = ButtonState.fail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Upload",
              icon: Icon(Icons.file_upload, color: Colors.white),
              color: Theme.of(context).accentColor),
          ButtonState.loading: IconedButton(
              text: "Loading", color: Theme.of(context).accentColor),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade300),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        onPressed: () => {
              state == ButtonState.idle
                  ? handleUpload(widget.image, widget.panelLocation)
                  : null
            },
        state: state);
  }
}
