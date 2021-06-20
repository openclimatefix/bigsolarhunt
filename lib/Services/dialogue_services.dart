import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bigsolarhunt/DataStructs/badge.dart';

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
      content: new Text(desc,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
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

class BadgeUnlockedDialogue extends StatelessWidget {
  final Badge badge;
  const BadgeUnlockedDialogue({Key key, @required this.badge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(children: [
        Padding(padding: EdgeInsets.only(top: 12), child: Icon(Icons.cake)),
        Text("You've unlocked a badge!")
      ]),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
          },
        )
      ],
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Image.asset(badge.imagePath),
            Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(badge.description, textAlign: TextAlign.center))
          ],
        ),
      ),
    );
  }
}

class BadgeInspectDialogue extends StatelessWidget {
  final Badge badge;
  const BadgeInspectDialogue({Key key, @required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = badge.unlocked ? Icons.cake : Icons.lock_outline;
    String imagePath =
        badge.unlocked ? badge.imagePath : 'assets/badges/unachieved.png';
    String description =
        badge.unlocked ? badge.description : "This badge is locked";

    return AlertDialog(
      title: Column(children: [
        Padding(padding: EdgeInsets.only(top: 12), child: Icon(icon)),
        Text(badge.id)
      ]),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Image.asset(imagePath),
            Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(description, textAlign: TextAlign.center)),
            badge.unlocked
                ? Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                        "Unlocked on " + formattedDate(badge.dateUnlocked),
                        textAlign: TextAlign.center))
                : Container()
          ],
        ),
      ),
    );
  }
}

String formattedDate(DateTime date) {
  return DateFormat('E').format(date) +
      ", " +
      date.day.toString() +
      " " +
      DateFormat('MMM').format(date) +
      " " +
      date.year.toString() +
      " at " +
      DateFormat('Hm').format(date);
}
