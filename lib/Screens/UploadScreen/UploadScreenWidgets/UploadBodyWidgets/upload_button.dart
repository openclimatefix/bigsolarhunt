import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'dart:io';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:solar_streets/DataStructs/solar_panel.dart';

import 'package:solar_streets/Services/mapillary_service.dart';
import 'UploadButtonWidgets/upload_dialogues.dart';
import 'package:solar_streets/Services/database_services.dart';
import 'package:solar_streets/DataStructs/badge.dart';

class UploadButton extends StatefulWidget {
  // Dynamic button able to upload a File to OSM and display status
  //  of the async OSM API calls
  final File imageFile;
  final LatLng panelLocation;
  final Function fineTuneLocation;
  const UploadButton(
      {Key key, this.imageFile, this.panelLocation, this.fineTuneLocation})
      : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  MapillaryService mapillaryService = new MapillaryService();
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  ButtonState state = ButtonState.idle;

  void handleUpload(imageFile, panelLocation) async {
    _displayLoading();
    var responseImage;
    try {
      responseImage = await mapillaryService.upload(imageFile, panelLocation);
    } catch (e) {
      _displayFailure();
      print(e);

      showDialog(
          context: context, builder: (_) => new UploadFailedDialogue(error: e));
      return null;
    }
    SolarPanel newPanel = SolarPanel(
        id: null, lat: panelLocation.latitude, lon: panelLocation.longitude);
    panelDatabase.insertUserPanel(newPanel);
    _displaySuccess();
    List<Badge> unlockedBadges =
        await panelDatabase.checkForNewBadges(newPanel);

    showDialog(
        context: context,
        builder: (_) =>
            new UploadCompleteDialogue(unlockedBadges: unlockedBadges));
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
          // If panel location is null, show Edit Location button
          // else show upload button
          ButtonState.idle: widget.panelLocation == null
              ? IconedButton(
                  text: "Edit Location",
                  icon: Icon(Icons.location_searching, color: Colors.white),
                  color: Colors.blueGrey)
              : IconedButton(
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
              widget.panelLocation == null
                  // If panel location is null, pressing buttons triggers
                  //  FineTuneLocation function from UploadScreen
                  ? widget.fineTuneLocation()
                  // Else display upload button
                  : state == ButtonState.idle
                      ? handleUpload(widget.imageFile, widget.panelLocation)
                      // Only allow for pressing if button is in idle state
                      : null
            },
        state: state);
  }
}
