import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double length = MediaQuery.of(context).size.width * 0.27;
    return Container(
      width: length,
      height: length,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}
