import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a photo'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Center(
            child: Text('Upload Screen', style: TextStyle(fontSize: 40))),
      ),
    );
  }
}
