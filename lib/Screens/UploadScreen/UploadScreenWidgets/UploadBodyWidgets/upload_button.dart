// Upload button is what triggers an image upload to Mapillary/telegram
// TODO: Have it handle an upload to AWS instead

import 'package:bigsolarhunt/Services/telegram_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:bigsolarhunt/DataStructs/solar_panel.dart';
import 'UploadButtonWidgets/upload_dialogues.dart';
import 'package:bigsolarhunt/Services/dialogue_services.dart';
import 'package:bigsolarhunt/Services/database_services.dart';
import 'package:bigsolarhunt/Services/internet_services.dart';
import 'package:bigsolarhunt/DataStructs/badge.dart';

/// Dynamic button able to upload a File to OSM and display status
///  of the async OSM API calls
class UploadButton extends StatefulWidget {

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
  // TODO: Change the telegram service here to an AWS service
  final TelegramBot telegramBot = TelegramBot();

  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  ButtonState state = ButtonState.idle;
  bool connected = false;

  Future _checkConnectivity() async {
    bool result = await checkConnection();
    result = result == null ? false : result;
    setState(() {
      connected = result;
    });
  }

  /// handleUpload calls the upload function for Mapillary
  /// (currently calls telegram as a workaround)
  void handleUpload(File imageFile, LatLng panelLocation) async {
    _displayLoading();

    SolarPanel newPanel = SolarPanel(
        id: null,
        lat: panelLocation.latitude,
        lon: panelLocation.longitude,
        path: imageFile.path,
        date: DateTime.now(),
        uploaded: true);

    if (connected) {
      // Upon introduction of AWS, this can be changed to e.g. awsservice.upload
      bool uploaded = await telegramBot.userUpload(newPanel);
      if (uploaded) {
        await panelDatabase.insertUserPanel(newPanel);
      } else {
        await panelDatabase.insertQueuePanel(newPanel);
        _displayFailure();
        showDialog(
            context: context,
            builder: (_) => new FailureDialogue(
                error: Exception("Failed to upload. Panel added to queue.")));
        return;
      }
    } else {
      await panelDatabase.insertQueuePanel(newPanel);
    }
    _displaySuccess();

    List<Badge> unlockedBadges =
        await panelDatabase.checkForNewBadges(newPanel);

    if (unlockedBadges.length == 0) {
      !connected
          ? showDialog(
              context: context, builder: (_) => new UploadLaterDialogue())
          : showDialog(
              context: context, builder: (_) => new UploadCompleteDialogue());
    } else {
      unlockedBadges.forEach((badge) {
        showDialog(
            context: context,
            builder: (_) => new BadgeUnlockedDialogue(badge: badge));
      });
    }
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
  void initState() {
    _checkConnectivity();
    super.initState();
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
              : !connected
                  ? IconedButton(
                      text: "Queue Image",
                      icon: Icon(Icons.file_upload,
                          color: Theme.of(context).colorScheme.onSecondary),
                      color: Theme.of(context).colorScheme.secondary)
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
