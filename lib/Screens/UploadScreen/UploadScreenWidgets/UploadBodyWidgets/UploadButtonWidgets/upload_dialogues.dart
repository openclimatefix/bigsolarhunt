import 'package:flutter/material.dart';

import 'package:solar_streets/DataStructs/badge.dart';

class UploadCompleteDialogue extends StatelessWidget {
  final List<Badge> unlockedBadges;
  const UploadCompleteDialogue({Key key, @required this.unlockedBadges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Upload Complete!",
          style: Theme.of(context).textTheme.headline5),
      content: unlockedBadges.isEmpty
          ? new Text("Thanks for contributing to Open Climate Fix!",
              style: Theme.of(context).textTheme.bodyText1)
          : new Text("You've unlocked a badge!",
              style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        )
      ],
    );
  }
}

class UploadLaterDialogue extends StatelessWidget {
  const UploadLaterDialogue({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("No internet connection.",
          style: Theme.of(context).textTheme.headline5),
      content: new Text("The picture will be uploaded automatically later.",
          style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        )
      ],
    );
  }
}

class UploadFailedDialogue extends StatelessWidget {
  final dynamic error;

  const UploadFailedDialogue({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Upload Failed",
          style: Theme.of(context).textTheme.headline5),
      content: new Text(error.toString(),
          style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
