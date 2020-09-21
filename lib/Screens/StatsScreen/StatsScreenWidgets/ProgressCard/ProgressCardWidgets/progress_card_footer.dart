import 'package:flutter/material.dart';

import 'package:solar_streets/Progress/progress_utilities.dart';
import 'package:solar_streets/Services/database_services.dart';

class ProgressCardFooter extends StatefulWidget {
  const ProgressCardFooter({Key key}) : super(key: key);

  @override
  _ProgressCardFooterState createState() => _ProgressCardFooterState();
}

class _ProgressCardFooterState extends State<ProgressCardFooter> {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  int _userPanels = 0;

  @override
  void initState() {
    super.initState();

    panelDatabase.getUserPanelCount().then((value) {
      setState(() {
        _userPanels = value;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentLevel = panelsToLevel(_userPanels);
    final int panelsForNextLevel = levelToPanels[currentLevel + 1];
    final int panelsToNextLevel = panelsForNextLevel - _userPanels;

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 10),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/panel-icon-light.png')))),
        Text(
            panelsToNextLevel == 1
                ? "$panelsToNextLevel Panel to next level"
                : "$panelsToNextLevel Panels to next level",
            style: Theme.of(context).textTheme.bodyText2)
      ],
    ));
  }
}
