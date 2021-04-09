import 'package:flutter/material.dart';

import 'package:solar_hunt/Services/markdown_services.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key key,
  }) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

String file = "infoscreen.md";

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: ScrollableTextFromMdFile(
          mdfile: "assets/text/infoscreen.md",
        ));
  }
}
