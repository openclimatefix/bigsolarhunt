import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_hunt/Services/internet_services.dart';
import 'package:solar_hunt/Themes/themes.dart';

import 'Animation/page_route_animations.dart';
import 'Screens/InfoScreen/info_screen.dart';
import 'Screens/MapScreen/osm_map.dart';
import 'Screens/StatsScreen/stats_screen.dart';
import 'Services/mapillary_service.dart';
import 'Services/dialogue_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapillaryService mapillaryService = new MapillaryService();
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  bool loggedInWithMapilliary;
  bool connected;

  @override
  void initState() {
    _checkConnectivity();
    checkMapilliaryLoginState();
    super.initState();
  }

  Future _checkConnectivity() async {
    bool result = await checkConnection();
    result = result == null ? false : result;
    setState(() {
      connected = result;
    });
  }

  checkMapilliaryLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sfBool = prefs.getBool('ownAccount');
    setState(() {
      loggedInWithMapilliary = sfBool;
    });
  }

  void handleOptionsClick(String value) async {
    switch (value) {
      case 'Toggle theme':
        solarTheme.switchTheme();
        break;
      case 'Upload queue items':
        bool uploaded = await mapillaryService.uploadQueuePanels();
        if (uploaded) {
          showDialog(
              context: context,
              builder: (_) => new GenericDialogue(
                  title: "Upload Successful",
                  desc: "Queue panels uploaded!",
                  icon: DialogueIcons.SUCCESS));
        } else {
          showDialog(
              context: context,
              builder: (_) => new GenericDialogue(
                  title: "Upload Failed",
                  desc:
                      "We couldn't upload your queued panels! Try again later.",
                  icon: DialogueIcons.ERROR));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Destination _currentDestination = allDestinations[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: handleOptionsClick,
              itemBuilder: (BuildContext context) {
                return {'Toggle theme', 'Upload queue items'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    enabled: choice == "Toggle theme" ? true : connected,
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
        title: Text(allDestinations[_currentIndex].title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
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
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
            icon: Icon(destination.icon),
            activeIcon: Icon(
              destination.icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: destination.title,
          );
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "uploadbtn",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add_a_photo,
            color: Theme.of(context).colorScheme.onSecondary),
        onPressed: () => Navigator.pushNamed(context, '/upload'),
      ),
    );
  }
}

class Destination {
  Destination(this.index, this.title, this.route, this.screen, this.icon);
  final int index;
  final String title;
  final String route;
  final IconData icon;
  final Widget screen;
}

List<Destination> allDestinations = <Destination>[
  Destination(0, 'The Big Solar Hunt', '/', OpenStreetMapScreen(),
      Icons.place), ////Icons.public
  Destination(1, 'Stats', '/stats', StatsScreen(), Icons.equalizer),
  Destination(2, 'Info', '/info', InfoScreen(), Icons.info_outline),
];
