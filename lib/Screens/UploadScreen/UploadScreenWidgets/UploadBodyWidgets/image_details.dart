import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'ImageDetailsWidgets/static_map.dart';

class ImageDetails extends StatelessWidget {
  final LatLng panelPosition;
  final Function fineTuneLocation;

  const ImageDetails(
      {Key key, @required this.panelPosition, @required this.fineTuneLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    return Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.only(top: 16, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(formattedDate(date)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "LOCATION",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 10),
                  ),
                  // InkWell(
                  //    child: Text("Edit",
                  //        style: Theme.of(context).textTheme.button.copyWith(
                  //            color: Theme.of(context).colorScheme.secondary)),
                  //    onTap: fineTuneLocation)
                ]),
            panelPosition == null
                ? Center(
                    child: Text(
                        "Could not get panel position from EXIF data. Please enable location services."))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Container(
                            child: StaticMap(panelPosition: panelPosition),
                            padding: EdgeInsets.only(top: 16),
                            height: 200),
                        Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text(
                                panelPosition.latitude.toStringAsPrecision(4) +
                                    ", " +
                                    panelPosition.longitude
                                        .toStringAsPrecision(4))),
                        Divider(),
                        Container(height: 100)
                      ])
          ],
        ));
  }
}

String formattedDate(DateTime date) {
  return DateFormat('E').format(date) +
      ", " +
      date.day.toString() +
      " " +
      DateFormat('MMM').format(date) +
      " " +
      date.year.toString() +
      " at " +
      DateFormat('Hm').format(date);
}
