import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:solar_hunt/Progress/progress_utilities.dart';
import 'package:solar_hunt/Services/database_services.dart';

class ProgressCardBody extends StatefulWidget {
  const ProgressCardBody({Key key}) : super(key: key);

  @override
  _ProgressCardBodyState createState() => _ProgressCardBodyState();
}

class _ProgressCardBodyState extends State<ProgressCardBody> {
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
    return Row(
      children: <Widget>[
        LevelIndicator(numPanels: _userPanels, isLeftIndicator: true),
        Expanded(child: ProgressBar(numPanels: _userPanels)),
        LevelIndicator(
          numPanels: _userPanels,
          isLeftIndicator: false,
        )
      ],
    );
  }
}

class LevelIndicator extends StatelessWidget {
  final int numPanels;
  final bool isLeftIndicator;

  const LevelIndicator(
      {Key key, @required this.numPanels, @required this.isLeftIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentLevel = panelsToLevel(numPanels);

    return Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLeftIndicator
                ? Theme.of(context).accentColor
                : Colors.black12),
        child: Center(
            child: Text(
                isLeftIndicator
                    ? (currentLevel).toString()
                    : (currentLevel + 1).toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.white))));
  }
}

class ProgressBar extends StatelessWidget {
  final int numPanels;

  const ProgressBar({Key key, @required this.numPanels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentLevel = panelsToLevel(numPanels);
    final int panelsForCurrentLevel = levelToPanels[currentLevel];
    final int panelsForNextLevel = levelToPanels[currentLevel + 1];

    return StepProgressIndicator(
      padding: 0,
      totalSteps: panelsForNextLevel - panelsForCurrentLevel,
      currentStep: numPanels - panelsForCurrentLevel,
      size: 20,
      selectedColor: Colors.amber,
      unselectedColor: Colors.black12,
      roundedEdges: Radius.circular(10),
      selectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Theme.of(context).accentColor, Colors.yellow],
      ),
    );
  }
}
