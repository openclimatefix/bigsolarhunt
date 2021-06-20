import 'package:flutter/material.dart';

import 'package:bigsolarhunt/Services/database_services.dart';
import 'package:bigsolarhunt/Services/markdown_services.dart';

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
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 5),
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
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).colorScheme.primary, fontSize: 60));
    } else if (_userPanels <= 999) {
      return Text(_userPanels.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).colorScheme.primary, fontSize: 44));
    } else if (_userPanels <= 9999) {
      return Text(_userPanels.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).colorScheme.primary, fontSize: 34));
    } else if (_userPanels <= 100000) {
      return Text(_userPanels.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).colorScheme.primary, fontSize: 24));
    } else {
      return Text((100000 - 1).toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).colorScheme.primary));
    }
  }
}

class ProgressCardHeaderText extends StatelessWidget {
  const ProgressCardHeaderText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.48,
        child: BodyTextFromMdFile(mdfile: 'assets/text/progresscard.md'));
  }
}
