import 'package:flutter/material.dart';
import 'dart:io';
import 'package:latlong/latlong.dart';

import 'UploadBodyWidgets/upload_button.dart';
import 'UploadBodyWidgets/image_with_column_overlap.dart';
import 'UploadBodyWidgets/image_details.dart';

class UploadBody extends StatelessWidget {
  final File imageFile;
  final LatLng panelPosition;
  final Function fineTuneLocation;

  const UploadBody(
      {Key key,
      @required this.imageFile,
      @required this.panelPosition,
      @required this.fineTuneLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ListView(children: <Widget>[
        ImageWithColumnOverlap(imageFile: imageFile),
        Divider(
            thickness: 2,
            height: 2,
            indent: MediaQuery.of(context).size.width * 0.4,
            endIndent: MediaQuery.of(context).size.width * 0.4),
        ImageDetails(
            panelPosition: panelPosition, fineTuneLocation: fineTuneLocation)
      ]),
      Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 12),
          child: UploadButton(
              imageFile: imageFile,
              panelLocation: panelPosition,
              fineTuneLocation: fineTuneLocation))
    ]);
  }
}
