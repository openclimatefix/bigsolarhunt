import 'package:flutter/material.dart';
import 'package:solar_hunt/DataStructs/badge.dart';
import 'package:solar_hunt/Services/dialogue_services.dart';

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
      width: length,
      height: length,
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(6),
              child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => new BadgeInspectDialogue(badge: badge));
                  },
                  child: Opacity(
                      opacity: opacity, child: Image.asset(imagePath)))),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}
