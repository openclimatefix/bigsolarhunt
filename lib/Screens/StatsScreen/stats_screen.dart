import 'package:flutter/material.dart';

import 'StatsScreenWidgets/ProgressCard/progress_card.dart';
import 'StatsScreenWidgets/BadgeGrid/badge_grid.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    Key key,
  }) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(20),
          child: Text("Your progress",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.lightBlue),
              textAlign: TextAlign.left)),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20), child: ProgressCard()),
      Padding(
          padding: EdgeInsets.all(20),
          child: Text("Your badges",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.lightBlue),
              textAlign: TextAlign.left)),
      Padding(padding: EdgeInsets.only(left: 20, right: 20), child: BadgeGrid())
    ]));
  }
}
