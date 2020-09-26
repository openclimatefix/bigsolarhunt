import 'package:flutter/material.dart';

import 'package:solar_streets/Progress/progress_utilities.dart';
import 'package:solar_streets/Services/database_services.dart';

class ProgressCardHeader extends StatelessWidget {
  const ProgressCardHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[PanelCountDisplay(), ProgressCardHeaderText()],
    );
  }
}

class PanelCountDisplay extends StatelessWidget {
  const PanelCountDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.26,
        width: MediaQuery.of(context).size.width * 0.26,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 5),
            shape: BoxShape.circle),
        child: Center(child: PanelCountDisplayText()));
  }
}

class PanelCountDisplayText extends StatefulWidget {
  const PanelCountDisplayText({Key key}) : super(key: key);

  @override
  _PanelCountDisplayTextState createState() => _PanelCountDisplayTextState();
}

class _PanelCountDisplayTextState extends State<PanelCountDisplayText> {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  int _uploadPanels = 0;
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
    if (_userPanels <= 99) {
      return Text(_userPanels.toString(),
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(color: Colors.greenAccent));
    } else if (_userPanels <= 999) {
      return Text(_userPanels.toString(),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.greenAccent));
    } else if (_userPanels <= 9999) {
      return Text(_userPanels.toString(),
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.greenAccent));
    } else if (_userPanels <= maxPanels) {
      return Text(_userPanels.toString(),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.greenAccent));
    } else {
      return Text((maxPanels - 1).toString(),
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.greenAccent));
    }
  }
}

class ProgressCardHeaderText extends StatefulWidget {
  const ProgressCardHeaderText({Key key}) : super(key: key);

  @override
  _ProgressCardHeaderTextState createState() => _ProgressCardHeaderTextState();
}

class _ProgressCardHeaderTextState extends State<ProgressCardHeaderText> {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  int _uploadPanels = 0;

  @override
  void initState() {
    super.initState();

    panelDatabase.getUploadQueueCount().then((value) {
      setState(() {
        _uploadPanels = value;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.48,
        child: Column(
          children: <Widget>[
            Text(
              "Panels sumbitted",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
            Divider(thickness: 2),
            _uploadPanels > 0
                ? Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 1),
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/panel-icon-orange.png')))),
                      Text(
                          _uploadPanels == 1
                              ? "$_uploadPanels panel to be uploaded later"
                              : "$_uploadPanels panel to be uploaded later",
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
                  )
                : Text('Each panel helps improve our predictions and save CO2')
          ],
        ));
  }
}
