import 'package:flutter/material.dart';

class GenericDialogue extends StatelessWidget {
  final String title;
  final String desc;
  final Icon icon;

  const GenericDialogue(
      {Key key, @required this.title, @required this.desc, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(children: [
        Padding(padding: EdgeInsets.only(bottom: 12), child: icon),
        Text(title, style: Theme.of(context).textTheme.headline5)
      ]),
      content: new Text(desc, style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/');
          },
        )
      ],
    );
  }
}

class DialogueIcons {
  static const Icon ERROR = Icon(
    Icons.error_outline,
    color: Colors.red,
    size: 40,
  );
  static const Icon WARNING = Icon(
    Icons.info_outline,
    color: Colors.amber,
    size: 40,
  );
  static const Icon SUCCESS = Icon(
    Icons.check_circle_outline,
    color: Colors.lightGreen,
    size: 40,
  );
}
