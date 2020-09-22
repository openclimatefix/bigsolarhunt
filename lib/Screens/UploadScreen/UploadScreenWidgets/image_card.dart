import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'dart:io';

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
  final ImageProvider image;
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
                  image: image,
                  fit: BoxFit.fitWidth,
                  placeholder: ImagePlaceholder()),
        ));
  }
}
