import 'package:flutter/material.dart';

import 'package:solar_streets/DataStructs/badge.dart';
import 'package:solar_streets/Services/dialogue_services.dart';

class UploadCompleteDialogue extends StatelessWidget {
  final List<Badge> unlockedBadges;
  const UploadCompleteDialogue({Key key, @required this.unlockedBadges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericDialogue(
        title: "Upload Complete!",
        desc: unlockedBadges.isEmpty
            ? "Thanks for contributing to Open Climate Fix!"
            : "You've unlocked a badge!",
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
