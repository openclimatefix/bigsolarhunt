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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
            index: _currentIndex,
            children: [MapScreen(), StatsScreen(), InfoScreen()]),
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
        items: [
          BottomNavigationBarItem(title: Text('Map'), icon: Icon(Icons.map)),
          BottomNavigationBarItem(
              title: Text('Stats'), icon: Icon(Icons.pie_chart)),
          BottomNavigationBarItem(title: Text('Info'), icon: Icon(Icons.info))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () => Navigator.pushNamed(context, '/upload'),
      ),
    );
  }
}
