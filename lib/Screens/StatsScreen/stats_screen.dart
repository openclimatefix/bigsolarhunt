import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    Key key,
  }) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child:
            Center(child: Text('Stats Screen', style: TextStyle(fontSize: 40))),
      ),
    );
  }
}
