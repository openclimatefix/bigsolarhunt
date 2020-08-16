import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key key,
  }) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child:
            // Placeholder
            Center(child: Text('Info Screen', style: TextStyle(fontSize: 40))),
      ),
    );
  }
}
