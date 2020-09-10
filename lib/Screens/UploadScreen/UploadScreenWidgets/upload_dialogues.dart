import 'package:flutter/material.dart';

class UploadCompleteDialogue extends StatelessWidget {
  const UploadCompleteDialogue({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Upload Complete!",
          style: Theme.of(context).textTheme.headline5),
      content: new Text("Thanks for contributing to Open Climate Fix!",
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
