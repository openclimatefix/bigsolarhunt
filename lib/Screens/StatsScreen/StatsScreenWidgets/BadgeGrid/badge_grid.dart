import 'package:flutter/material.dart';

import 'BadgeGridWidgets/badge_card.dart';

class BadgeGrid extends StatelessWidget {
  const BadgeGrid({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[BadgeCard(), BadgeCard(), BadgeCard()]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[BadgeCard(), BadgeCard(), BadgeCard()]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[BadgeCard(), BadgeCard(), BadgeCard()])
      ],
    );
  }
}
