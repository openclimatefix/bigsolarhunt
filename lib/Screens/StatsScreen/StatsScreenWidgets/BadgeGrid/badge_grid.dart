import 'package:flutter/material.dart';

import 'BadgeGridWidgets/badge_card.dart';
import 'package:bigsolarhunt/DataStructs/badge.dart';
import 'package:bigsolarhunt/Services/database_services.dart';

class BadgeGrid extends StatefulWidget {
  const BadgeGrid({
    Key key,
  }) : super(key: key);

  @override
  _BadgeGridState createState() => _BadgeGridState();
}

class _BadgeGridState extends State<BadgeGrid> {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  List<Badge> _badges = [];
  //Important to set as empty to avoid millisecond of error before fetch is done

  _getUserBadges() async {
    List<Badge> badgeData = await panelDatabase.getUserBadgeData();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _badges = badgeData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (_badges.length == 0)
          ? Padding(
              padding: EdgeInsets.all(70),
            )
          : Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _badges.sublist(0, 3).map((Badge badge) {
                      return BadgeCard(badge: badge);
                    }).toList()),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _badges.sublist(3, 6).map((Badge badge) {
                      return BadgeCard(badge: badge);
                    }).toList()),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _badges.sublist(6).map((Badge badge) {
                      return BadgeCard(badge: badge);
                    }).toList())
              ],
            ),
    );
  }
}
