import 'package:flutter/material.dart';

import 'package:bigsolarhunt/Services/markdown_services.dart';

class OnboardingPage extends StatelessWidget {
  final String mdfile;
  final Widget widget;
  const OnboardingPage({Key key, @required this.mdfile, @required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.only(bottom: 150, top: 40, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: Center(child: widget)),
            BodyTextFromMdFile(mdfile: mdfile)
          ],
        ),
      ),
    );
  }
}
