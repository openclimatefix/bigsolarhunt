import 'package:flutter/material.dart';

import 'ProgressCardWidgets/progress_card_body.dart';
import 'ProgressCardWidgets/progress_card_header.dart';
import 'ProgressCardWidgets/progress_card_footer.dart';

class ProgressCard extends StatelessWidget {
  final int numPanelsSubmitted = 44;
  const ProgressCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              ProgressCardHeader(),
              Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: ProgressCardBody()),
              ProgressCardFooter()
            ])));
  }
}
