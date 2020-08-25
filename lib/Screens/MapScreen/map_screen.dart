import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:solar_streets/Model/map_marker.dart';
import 'package:solar_streets/Model/solar_panel.dart';
import 'package:solar_streets/Services/osm_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _mapController;
  List<String> _mapStyles = List<String>(2);
  List<BitmapDescriptor> _pinLocationIcons = List<BitmapDescriptor>(2);
  OSMService osmService = new OSMService();
  Location location = new Location();
  static LatLng _userLocation;
  static List<SolarPanel> _solarPanelData;
  Fluster<MapMarker> _fluster;
  List<Marker> _markers = [];
  static const int _MARKER_LIMIT = 5000;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getSolarPanelData();
    _setCustomMapPin();
    _setMapStyle();
  }

  _setCustomMapPin() async {
    final Uint8List darkMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-orange-dark.png', 50);
    final Uint8List lightMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-orange.png', 50);
    setState(() {
      _pinLocationIcons[0] = BitmapDescriptor.fromBytes(lightMarkerIcon);
      _pinLocationIcons[1] = BitmapDescriptor.fromBytes(darkMarkerIcon);
    });
  }

  _setMapStyle() async {
    final String darkMapStyle =
        await rootBundle.loadString('assets/map_style_dark.json');
    final String lightMapStyle =
        await rootBundle.loadString('assets/map_style_light.json');
    setState(() {
      _mapStyles[0] = lightMapStyle;
      _mapStyles[1] = darkMapStyle;
    });
  }

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      _userLocation = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  _getSolarPanelData() async {
    await osmService.updatePanelData();
    List<SolarPanel> solarPanelData = await osmService.getPanelData();
    setState(() {
      solarPanelData.shuffle();
      _solarPanelData = solarPanelData.sublist(0, _MARKER_LIMIT);
    });
  }

  _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    int themeIdentifier =
        Theme.of(context).brightness == Brightness.light ? 0 : 1;
    _mapController.setMapStyle(_mapStyles[themeIdentifier]);
    _initializeClusters(_solarPanelData, themeIdentifier);
    final double zoomLevel = await _mapController.getZoomLevel();
    setState(() {
      _markers = _fluster
          .clusters([-180, -85, 180, 85], zoomLevel.toInt())
          .map((cluster) => cluster.toMarker())
          .toList();
    });
  }

  _onCameraIdle() async {
    final double zoomLevel = await _mapController.getZoomLevel();
    setState(() {
      _markers = _fluster
          .clusters([-180, -85, 180, 85], zoomLevel.toInt())
          .map((cluster) => cluster.toMarker())
          .toList();
    });
  }

  _initializeClusters(List<SolarPanel> newPanels, int themeIdentifier) {
    final List<MapMarker> markers = [];
    for (final solarPanel in newPanels) {
      markers.add(MapMarker(
          id: solarPanel.id.toString(),
          position: LatLng(solarPanel.lat, solarPanel.lon),
          icon: _pinLocationIcons[themeIdentifier]));
    }
    final Fluster<MapMarker> fluster = Fluster<MapMarker>(
        minZoom: 0,
        maxZoom: 20,
        radius: 150,
        extent: 2048,
        nodeSize: 64,
        points: markers,
        createCluster: (BaseCluster cluster, double lng, double lat) =>
            MapMarker(
                id: cluster.id.toString(),
                position: LatLng(lat, lng),
                icon: _pinLocationIcons[themeIdentifier],
                isCluster: cluster.isCluster,
                clusterId: cluster.id,
                pointsSize: cluster.pointsSize,
                childMarkerId: cluster.childMarkerId));
    setState(() {
      _fluster = fluster;
    });
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_userLocation == null) || (_solarPanelData == null)
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          : Container(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                markers: _markers.toSet(),
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 5.0,
                ),
                onCameraIdle: _onCameraIdle,
              ),
            ),
    );
  }
}
