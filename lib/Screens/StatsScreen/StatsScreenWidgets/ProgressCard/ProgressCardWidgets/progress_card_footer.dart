import 'package:flutter/material.dart';

import 'package:solar_hunt/Services/database_services.dart';
import 'package:solar_hunt/DataStructs/badge.dart';

class ProgressCardFooter extends StatefulWidget {
  const ProgressCardFooter({Key key}) : super(key: key);

  @override
  _ProgressCardFooterState createState() => _ProgressCardFooterState();
}

class _ProgressCardFooterState extends State<ProgressCardFooter> {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  int _userPanels = 0;
  int _queuePanels = 0;

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
    panelDatabase.getUploadQueueCount().then((value) {
      setState(() {
        _queuePanels = value;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    String _panelIconString =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/icons/panel-icon-light.png'
            : 'assets/icons/panel-icon-dark.png';
    String _panelIconQueueString =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/icons/panel-icon-queue-light.png'
            : 'assets/icons/panel-icon-queue-dark.png';

    int panelsToNextBadge = panelCountBadgeIntegers
            .firstWhere((i) => i > _userPanels, orElse: () => _userPanels) -
        _userPanels;

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 5, left: 5),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(_panelIconString)))),
        panelsToNextBadge > 0
            ? Text("$panelsToNextBadge to next badge",
                style: Theme.of(context).textTheme.bodyText2)
            : Container(),
        _queuePanels > 0
            ? Row(children: [
                Container(
                    margin: EdgeInsets.only(right: 5, left: 15),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(_panelIconQueueString)))),
                Text("$_queuePanels in queue",
                    style: Theme.of(context).textTheme.bodyText2)
              ])
            : Container(),
      ],
    ));
  }
}
