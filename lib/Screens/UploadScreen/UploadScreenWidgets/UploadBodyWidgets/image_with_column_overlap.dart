import 'package:flutter/material.dart';
import 'dart:io';

class ImageWithColumnOverlap extends StatelessWidget {
  final File imageFile;
  const ImageWithColumnOverlap({Key key, @required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(child: Image.file(imageFile)),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
              height: 10,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)))))
    ]);
  }
}
