import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget widget;
  const OnboardingPage(
      {Key key,
      @required this.description,
      @required this.title,
      @required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            padding: EdgeInsets.only(bottom: 150, top: 40, left: 10, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Center(child: widget)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              this.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            )),
                        Text(
                          this.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ]),
                ])));
  }
}
