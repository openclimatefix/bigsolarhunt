import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Animation/page_route_animations.dart';
import 'Screens/InfoScreen/info_screen.dart';
import 'Screens/MapScreen/map_screen.dart';
import 'Screens/StatsScreen/stats_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Destination _currentDestination = allDestinations[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset('assets/logo_white.png'),
        ),
        actions: [],
        title: Text(allDestinations[_currentIndex].title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
          top: false,
          child: Navigator(
              key: _navigatorKey,
              initialRoute: '/',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder =
                    (BuildContext context) => _currentDestination.screen;
                return MaterialPageRoute(builder: builder, settings: settings);
              })),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            Widget screen = allDestinations[index].screen;
            _navigatorKey.currentState
                .pushReplacement(FadeThroughPageRoute(page: screen));
          }
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon,
                  color: Theme.of(context).iconTheme.color),
              activeIcon:
                  Icon(destination.icon, color: Theme.of(context).accentColor),
              backgroundColor: destination.color,
              title: Text(destination.title));
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/upload'),
      ),
    );
  }
}

class Destination {
  const Destination(
      this.index, this.title, this.route, this.screen, this.icon, this.color);
  final int index;
  final String title;
  final String route;
  final IconData icon;
  final MaterialColor color;
  final Widget screen;
}

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'Solar Streets', '/', MapScreen(), Icons.place,
      Colors.grey), //Icons.public
  Destination(
      1, 'Stats', '/stats', StatsScreen(), Icons.equalizer, Colors.purple),
  Destination(
      2, 'Info', '/info', InfoScreen(), Icons.info_outline, Colors.green),
];
