import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:solar_hunt/Services/internet_services.dart';
import 'package:solar_hunt/DataStructs/solar_panel.dart';
import 'package:solar_hunt/Services/database_services.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class OpenStreetMapScreen extends StatefulWidget {
  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  static Widget _panelMarker;
  static Widget _uploadMarker;
  static String _tileUrl;
  static List<Marker> _markers = [];
  static DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  CenterOnLocationUpdate _centerOnLocationUpdate;
  StreamController<double> _centerCurrentLocationStreamController;

  _getMapData(BuildContext context) async {
    _markers = [];
    await _getMarkers(context);
    bool connected = await checkConnection();
    return connected;
  }

  _getMarkers(BuildContext context) async {
    List<Marker> userPanelData = await _getUserPanels();
    List<Marker> uploadQueue = await _getUploadQueuePanels();
    _markers.addAll(userPanelData);
    _markers.addAll(uploadQueue);
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
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double>();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelMarker = Image.asset('assets/icons/panel-icon.png');
    _uploadMarker = Image.asset('assets/icons/panel-icon-queue.png');

    _tileUrl = Theme.of(context).brightness == Brightness.light
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
        : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';

    return Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: FutureBuilder(
            future: _getMapData(context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Column(
                  children: [
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                            center: LatLng(0, 0),
                            zoom: 5.3,
                            maxZoom: 18,
                            // Stop centering the location marker on the map if user interacted with the map.
                            onPositionChanged:
                                (MapPosition position, bool hasGesture) {
                              if (hasGesture) {
                                setState(() => _centerOnLocationUpdate =
                                    CenterOnLocationUpdate.never);
                              }
                            }),
                        children: [
                          TileLayerWidget(
                            options: TileLayerOptions(
                                urlTemplate: _tileUrl,
                                subdomains: ['a', 'b', 'c'],
                                tileProvider: NonCachingNetworkTileProvider(),
                                retinaMode: true &&
                                    MediaQuery.of(context).devicePixelRatio >
                                        1.0),
                          ),
                          MarkerLayerWidget(
                            options: MarkerLayerOptions(markers: _markers),
                          ),
                          LocationMarkerLayerWidget(
                            plugin: LocationMarkerPlugin(
                              centerCurrentLocationStream:
                                  _centerCurrentLocationStreamController.stream,
                              centerOnLocationUpdate: _centerOnLocationUpdate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data == false) {
                return Center(child: NotConnectedContainer(showtext: true));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Automatically center the location marker on the map when location updated until user interact with the map.
            setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.always);
            // Center the location marker on the map and zoom the map to level 18.
            _centerCurrentLocationStreamController.add(18);
          },
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
