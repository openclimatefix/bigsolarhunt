import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Indicator extends StatelessWidget {
  final int numPages;
  final double currentIndex;
  final Function onNextPage;
  final Function onClosePage;
  const Indicator(
      {Key key,
      @required this.numPages,
      @required this.currentIndex,
      @required this.onNextPage,
      @required this.onClosePage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    int currentIndexInt = (100 + currentIndex * 100).round();
    return CircularStepProgressIndicator(
        totalSteps: numPages * 100,
        currentStep: currentIndexInt,
        stepSize: 10,
        selectedColor: Colors.greenAccent,
        unselectedColor: Colors.grey[200],
        padding: 0,
        width: 80,
        height: 80,
        selectedStepSize: 10,
        roundedCap: (_, __) => true,
        child: currentIndexInt < ((numPages * 100) - 50)
            ? InkWell(
                child: Icon(Icons.chevron_right, size: 40), onTap: onNextPage)
            : InkWell(child: Icon(Icons.close, size: 40), onTap: onClosePage));
  }
}
