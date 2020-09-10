import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:solar_streets/Model/solar_panel.dart';
import 'package:solar_streets/Services/database_services.dart';

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
  OSMDatabaseProvider osmDatabase = OSMDatabaseProvider.databaseProvider;
  Location location = new Location();
  static LatLng _userLocation;
  bool _databaseConnected = false;
  List<Marker> _markers = [];
  static const int _MARKER_LIMIT = 5000;

  @override
  void initState() {
    super.initState();
    _connectDatabase();
    _getUserLocation();
    _setCustomMapPin();
    _setMapStyle();
  }

  _connectDatabase() async {
    await osmDatabase.database;
    setState(() {
      _databaseConnected = true;
    });
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

  _getMarkerData(LatLngBounds visibleRegion, int themeIdentifier) async {
    List<SolarPanel> solarPanelData =
        await osmDatabase.getPanelData(visibleRegion);
    List<Marker> markers = [];
    solarPanelData.forEach((panel) {
      markers.add(Marker(
        markerId: MarkerId(panel.id.toString()),
        position: LatLng(panel.lat, panel.lon),
        icon: _pinLocationIcons[themeIdentifier],
      ));
    });
    if (markers.length > 300) {
      markers = markers.sublist(0, 300);
    }
    setState(() {
      _markers = markers;
    });
  }

  _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    int themeIdentifier =
        Theme.of(context).brightness == Brightness.light ? 0 : 1;
    _mapController.setMapStyle(_mapStyles[themeIdentifier]);
  }

  _onCameraIdle() async {
    int themeIdentifier =
        Theme.of(context).brightness == Brightness.light ? 0 : 1;
    _getMarkerData(await _mapController.getVisibleRegion(), themeIdentifier);
  }

  // _initializeClusters(List<SolarPanel> newPanels, int themeIdentifier) {
  //   final List<MapMarker> markers = [];
  //   for (final solarPanel in newPanels) {
  //     markers.add(MapMarker(
  //         id: solarPanel.id.toString(),
  //         position: LatLng(solarPanel.lat, solarPanel.lon),
  //         icon: _pinLocationIcons[themeIdentifier]));
  //   }
  //   final Fluster<MapMarker> fluster = Fluster<MapMarker>(
  //       minZoom: 0,
  //       maxZoom: 20,
  //       radius: 150,
  //       extent: 2048,
  //       nodeSize: 64,
  //       points: markers,
  //       createCluster: (BaseCluster cluster, double lng, double lat) =>
  //           MapMarker(
  //               id: cluster.id.toString(),
  //               position: LatLng(lat, lng),
  //               icon: _pinLocationIcons[themeIdentifier],
  //               isCluster: cluster.isCluster,
  //               clusterId: cluster.id,
  //               pointsSize: cluster.pointsSize,
  //               childMarkerId: cluster.childMarkerId));
  //   setState(() {
  //     _fluster = fluster;
  //   });
  // }

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
      body: (_userLocation == null || !_databaseConnected)
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
                onCameraIdle: _onCameraIdle,
                markers: _markers.toSet(),
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 5.0,
                ),
              ),
            ),
    );
  }
}
