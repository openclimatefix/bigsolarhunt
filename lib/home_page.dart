import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Screens/InfoScreen/info_screen.dart';
import 'Screens/MapScreen.dart/map_screen.dart';
import 'Screens/StatsScreen/stats_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _faders =
        allDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(allDestinations.length, (int index) => GlobalKey())
            .toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: allDestinations.map((Destination destination) {
            final Widget view = FadeTransition(
              opacity: _faders[destination.index]
                  .drive(CurveTween(curve: Curves.fastOutSlowIn)),
              child: KeyedSubtree(
                  key: _destinationKeys[destination.index],
                  child: destination.screen),
            );
            if (destination.index == _currentIndex) {
              _faders[destination.index].forward();
              return view;
            } else {
              _faders[destination.index].reverse();
              if (_faders[destination.index].isAnimating) {
                return IgnorePointer(child: view);
              }
              return Offstage(child: view);
            }
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              backgroundColor: destination.color,
              title: Text(destination.title));
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () => Navigator.pushNamed(context, '/upload'),
      ),
    );
  }
}

class Destination {
  const Destination(this.index, this.title, this.screen, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
  final Widget screen;
}

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'Map', MapScreen(), Icons.map, Colors.grey),
  Destination(1, 'Stats', StatsScreen(), Icons.pie_chart, Colors.purple),
  Destination(2, 'Info', InfoScreen(), Icons.info, Colors.green),
];
