import 'package:flutter/material.dart';

import 'ProgressCardWidgets/progress_card_header.dart';
import 'ProgressCardWidgets/progress_card_footer.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          ProgressCardHeader(),
          Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: ProgressCardFooter())
        ]));
  }
}
