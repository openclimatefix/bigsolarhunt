import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bigsolarhunt/Services/internet_services.dart';

class StaticMap extends StatelessWidget {
  final LatLng panelPosition;

  const StaticMap({
    Key key,
    @required this.panelPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tileUrl = Theme.of(context).brightness == Brightness.light
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
        : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';

    Widget _uploadMarker = Image.asset('assets/icons/panel-icon-queue.png');
    List<Marker> markers = [
      Marker(
          point: panelPosition,
          builder: (ctx) => Container(child: _uploadMarker))
    ];

    return FutureBuilder(
        future: checkConnection(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return FlutterMap(
              options: MapOptions(
                center: panelPosition,
                zoom: 15,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: tileUrl,
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: NonCachingNetworkTileProvider(),
                ),
                MarkerLayerOptions(markers: markers),
              ],
            );
          } else if (snapshot.hasData && snapshot.data == false) {
            return Center(child: NotConnectedContainer(showtext: false));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
