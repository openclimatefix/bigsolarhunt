import 'package:flutter/material.dart';
import 'package:bigsolarhunt/DataStructs/badge.dart';
import 'package:bigsolarhunt/Services/dialogue_services.dart';

class BadgeCard extends StatelessWidget {
  final Badge badge;

  const BadgeCard({Key key, @required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath =
        badge.unlocked ? badge.imagePath : 'assets/badges/unachieved.png';
    double opacity = badge.unlocked ? 1 : 0.5;
    double length = MediaQuery.of(context).size.width * 0.27;
    return Container(
        margin: EdgeInsets.zero,
        width: length,
        height: length,
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => new BadgeInspectDialogue(badge: badge));
            },
            child: Opacity(opacity: opacity, child: Image.asset(imagePath))));
  }
}
