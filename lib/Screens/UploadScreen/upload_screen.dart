import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'UploadScreenWidgets/upload_button.dart';
import 'UploadScreenWidgets/image_card.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      print(_image);
    });
  }

  void _regetImage() {
    _image.delete();
    setState(() {
      _image = null;
    });
    _getImage();
  }

  @override
  void initState() {
    _getImage().then((value) {
      print('Got async image');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a photo'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: () => _regetImage())
        ],
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
          child: Stack(children: <Widget>[
        Container(
            // TODO: Map goes here
            color: Colors.blue,
            child: Center(child: Text('Current location on map'))),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: ImageCard(image: _image)),
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: UploadButton(image: _image))
      ])),
    );
  }
}
