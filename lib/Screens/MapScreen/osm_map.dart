import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';
import 'package:solar_hunt/DataStructs/solar_panel.dart';
import 'package:solar_hunt/Services/database_services.dart';

class OpenStreetMapScreen extends StatelessWidget {
  static Widget _panelMarker;
  static Widget _uploadMarker;
  static String _tileUrl;
  static List<Marker> _markers = [];
  static DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  static MapController mapController = MapController();
  static UserLocationOptions userLocationOptions;

  const OpenStreetMapScreen({
    Key key,
  }) : super(key: key);

  _getMapData(BuildContext context) async {
    _markers = [];
    await _getMarkers(context);
    return true;
  }

  _getMarkers(BuildContext context) async {
    List<Marker> userPanelData = await _getUserPanels();
    List<Marker> uploadQueue = await _getUploadQueuePanels();
    _markers.addAll(userPanelData);
    _markers.addAll(uploadQueue);
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: _markers,
        updateMapLocationOnPositionChange: false,
        moveToCurrentLocationFloatingActionButton: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface),
            child: Icon(Icons.gps_fixed_rounded,
                color: Theme.of(context).colorScheme.onSurface)));
  }

  Future<List<Marker>> _getUserPanels() async {
    List<SolarPanel> userPanelData = await panelDatabase.getUserPanels();
    List<Marker> markers = [];
    userPanelData.forEach((panel) {
      markers.add(Marker(
        width: 15.0,
        height: 15.0,
        point: LatLng(panel.lat, panel.lon),
        builder: (ctx) => Container(child: _panelMarker),
      ));
    });
    return markers;
  }

  Future<List<Marker>> _getUploadQueuePanels() async {
    List<SolarPanel> uploadQueue = await panelDatabase.getUploadQueue();
    List<Marker> markers = [];
    uploadQueue.forEach((panel) {
      markers.add(Marker(
        width: 15.0,
        height: 15.0,
        point: LatLng(panel.lat, panel.lon),
        builder: (ctx) => Container(child: _uploadMarker),
      ));
    });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    _panelMarker = Theme.of(context).brightness == Brightness.light
        ? Image.asset('assets/icons/panel-icon-light.png')
        : Image.asset('assets/icons/panel-icon-dark.png');

    _uploadMarker = Theme.of(context).brightness == Brightness.light
        ? Image.asset('assets/icons/panel-icon-queue-light.png')
        : Image.asset('assets/icons/panel-icon-queue-dark.png');

    _tileUrl = Theme.of(context).brightness == Brightness.light
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
        : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: FutureBuilder(
        future: _getMapData(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(54.12501425, -4.31989979),
                      zoom: 5.3,
                      maxZoom: 18,
                      plugins: [
                        UserLocationPlugin(),
                      ],
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate: _tileUrl,
                          subdomains: ['a', 'b', 'c'],
                          tileProvider: NonCachingNetworkTileProvider(),
                          retinaMode: true &&
                              MediaQuery.of(context).devicePixelRatio > 1.0),
                      MarkerLayerOptions(markers: _markers),
                      userLocationOptions,
                    ],
                    mapController: mapController,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
