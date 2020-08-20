import 'package:flutter/material.dart';
import 'dart:io';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class UploadButton extends StatefulWidget {
  // Dynamic button able to upload a File to OSM and display status
  //  of the async OSM API calls
  final File image;

  const UploadButton({Key key, this.image}) : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  ButtonState state = ButtonState.idle;

  void engageIdleState() {
    setState(() {
      state = ButtonState.idle;
    });
  }

  void beginUpload() {
    //TODO: Implement uploading of file image
    setState(() {
      state = ButtonState.loading;
    });
  }

  void displaySuccess() {
    setState(() {
      state = ButtonState.success;
    });
  }

  void displayFailure() {
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
              color: Colors.orange),
          ButtonState.loading:
              IconedButton(text: "Loading", color: Colors.orange),
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
        onPressed: () =>
            {state == ButtonState.idle ? beginUpload() : engageIdleState()},
        state: state);
  }
}
