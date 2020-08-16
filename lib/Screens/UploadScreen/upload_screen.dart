import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_fade/image_fade.dart';

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
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[100],
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
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              label: Text('Upload'),
              icon: Icon(Icons.cloud_upload),
              // TODO: Implement mappiliary API call
              onPressed: () => {print('Began upload to mapilliary API')},
            ))
      ])),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFCFCDCA),
      child: Center(
          child: Icon(
        Icons.photo,
        color: Colors.white30,
        size: 128.0,
      )),
    );
  }
}

class ImageCard extends StatelessWidget {
  final File image;
  const ImageCard({
    Key key,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 184,
          width: 214,
          child: image == null
              ? ImagePlaceholder()
              : ImageFade(
                  image: FileImage(image),
                  fit: BoxFit.fitWidth,
                  placeholder: ImagePlaceholder()),
        ));
  }
}
