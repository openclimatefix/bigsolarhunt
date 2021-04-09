import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'dart:io';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:solar_hunt/DataStructs/solar_panel.dart';

import 'package:solar_hunt/Services/mapillary_service.dart';
import 'UploadButtonWidgets/upload_dialogues.dart';
import 'package:solar_hunt/Services/dialogue_services.dart';
import 'package:solar_hunt/Services/database_services.dart';

import 'package:solar_hunt/DataStructs/badge.dart';

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

  void handleUpload(File imageFile, LatLng panelLocation) async {
    _displayLoading();
    var responseImage;
    SolarPanel newPanel = SolarPanel(
        id: null,
        lat: panelLocation.latitude,
        lon: panelLocation.longitude,
        date: DateTime.now());
    try {
      responseImage = await mapillaryService.upload(imageFile, newPanel);
    } catch (e) {
      _displayFailure();
      print(e);

      showDialog(
          context: context, builder: (_) => new FailureDialogue(error: e));
      return null;
    }

    _displaySuccess();
    List<Badge> unlockedBadges =
        await panelDatabase.checkForNewBadges(newPanel);

    if (unlockedBadges.length == 0) {
      showDialog(
          context: context, builder: (_) => new UploadCompleteDialogue());
    }

    unlockedBadges.forEach((badge) {
      showDialog(
          context: context,
          builder: (_) => new BadgeUnlockedDialogue(badge: badge));
    });
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
                  icon: Icon(Icons.location_searching,
                      color: Theme.of(context).colorScheme.onPrimary),
                  color: Theme.of(context).colorScheme.primaryVariant)
              : IconedButton(
                  text: "Upload",
                  icon: Icon(Icons.file_upload,
                      color: Theme.of(context).colorScheme.onSecondary),
                  color: Theme.of(context).colorScheme.secondary),
          ButtonState.loading: IconedButton(
              text: "Loading", color: Theme.of(context).colorScheme.secondary),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel,
                  color: Theme.of(context).colorScheme.onError),
              color: Theme.of(context).colorScheme.error),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(Icons.check_circle,
                  color: Theme.of(context).colorScheme.onSecondary),
              color: Theme.of(context).colorScheme.secondaryVariant)
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
