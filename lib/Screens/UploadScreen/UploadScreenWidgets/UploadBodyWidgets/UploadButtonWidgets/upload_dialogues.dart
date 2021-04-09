import 'package:flutter/material.dart';

import 'package:solar_hunt/Services/dialogue_services.dart';

class UploadCompleteDialogue extends StatelessWidget {
  const UploadCompleteDialogue({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericDialogue(
        title: "Upload Complete!",
        desc: "Thanks for contributing to Open Climate Fix!",
        icon: DialogueIcons.SUCCESS);
  }
}

class UploadLaterDialogue extends StatelessWidget {
  const UploadLaterDialogue({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericDialogue(
        title: "No internet connection.",
        desc: "The picture will be uploaded automatically later.",
        icon: DialogueIcons.WARNING);
  }
}

class FailureDialogue extends StatelessWidget {
  final dynamic error;

  const FailureDialogue({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericDialogue(
        title: "Upload Failed",
        desc: error.toString(),
        icon: DialogueIcons.ERROR);
  }
}
