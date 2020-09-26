import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:solar_streets/Model/map_panel.dart';
import 'package:solar_streets/Model/solar_panel.dart';
import 'package:solar_streets/Model/upload_queue_item.dart';
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
  // ClusterManager _manager;
  List<String> _mapStyles = List<String>(2);
  List<BitmapDescriptor> _pinLocationIcons = List<BitmapDescriptor>(4);
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  Location location = new Location();
  static LatLng _userLocation;
  bool _databaseConnected = false;
  // List<ClusterItem<MapPanel>> _clusterItems = [];
  // Set<Marker> _markers = Set();
  Set<Marker> _markers = Set();
  Set<Marker> _userPanelMarkers = Set();
  Set<Marker> _uploadQueueMarkers = Set();
  CameraPosition _initialPostion =
      CameraPosition(target: LatLng(54.12501425, -4.31989979), zoom: 5.3);
  int _themeIdentifier;

  @override
  void initState() {
    super.initState();
    _initMarkerData();
    _getUserLocation();
    _setMapStyle();
  }

  _initMarkerData() async {
    await panelDatabase.database;
    await _setCustomMapPin();
    // await _initClusterManager();
    _getMarkers();
    setState(() {
      _databaseConnected = true;
    });
  }

  _setCustomMapPin() async {
    final Uint8List darkUserMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-dark.png', 50);
    final Uint8List lightUserMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-light.png', 50);
    final Uint8List darkOSMMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-orange-dark.png', 50);
    final Uint8List lighOSMtMarkerIcon =
        await _getBytesFromAsset('assets/panel-icon-orange.png', 50);
    setState(() {
      _pinLocationIcons[0] = BitmapDescriptor.fromBytes(lighOSMtMarkerIcon);
      _pinLocationIcons[1] = BitmapDescriptor.fromBytes(darkOSMMarkerIcon);
      _pinLocationIcons[2] = BitmapDescriptor.fromBytes(lightUserMarkerIcon);
      _pinLocationIcons[3] = BitmapDescriptor.fromBytes(darkUserMarkerIcon);
    });
  }

  _setMapStyle() async {
    final String darkMapStyle =
        await rootBundle.loadString('assets/map_style_dark.json');
    final String lightMapStyle =
        await rootBundle.loadString('assets/map_style_light.json');
    setState(() {
      _themeIdentifier =
          Theme.of(context).brightness == Brightness.light ? 0 : 1;
      _mapStyles[0] = lightMapStyle;
      _mapStyles[1] = darkMapStyle;
    });
  }

  // _initClusterManager() async {
  //   await _getOSMClusters();
  //   setState(() {
  //     _manager = ClusterManager<MapPanel>(_clusterItems, _updateMarkers,
  //         markerBuilder: _markerBuilder,
  //         levels: [
  //           3,
  //           4,
  //           5,
  //           6,
  //           7,
  //           8,
  //           9,
  //           10,
  //           11,
  //           12,
  //           13,
  //           14,
  //           15,
  //           16,
  //           17
  //         ], // Optional : Configure this if you want to change zoom levels at which the clustering precision change
  //         extraPercent: 0.2,
  //         initialZoom: _initialPostion.zoom);
  //   });
  // }

  // Future<Marker> Function(Cluster<MapPanel>) get _markerBuilder =>
  //     (cluster) async {
  //       return Marker(
  //         markerId: MarkerId(cluster.getId()),
  //         position: cluster.location,
  //         onTap: () {
  //           print('---- $cluster');
  //           cluster.items.forEach((p) => print(p));
  //         },
  //         icon: _pinLocationIcons[_themeIdentifier],
  //       );
  //     };

  // _updateMarkers(Set<Marker> markers) {
  //   markers.addAll(_userPanelMarkers);
  //   setState(() {
  //     _markers = markers;
  //   });
  // }

  _getMarkers() async {
    List<Marker> userPanelData = await _getUserPanels();
    List<Marker> uploadQueue = await _getUploadQueuePanels();
    setState(() {
      _markers.addAll(userPanelData);
      _markers.addAll(uploadQueue);
    });
  }

  Future<List<Marker>> _getUserPanels() async {
    List<SolarPanel> userPanelData = await panelDatabase.getUserPanelData();
    List<Marker> markers = [];
    userPanelData.forEach((panel) {
      markers.add(Marker(
        markerId: MarkerId(panel.id.toString()),
        position: LatLng(panel.lat, panel.lon),
        icon: _pinLocationIcons[_themeIdentifier + 2],
      ));
    });
    return markers;
  }

  Future<List<Marker>> _getUploadQueuePanels() async {
    List<UploadQueueItem> uploadQueue = await panelDatabase.getUploadQueue();
    List<Marker> markers = [];
    uploadQueue.forEach((panel) {
      markers.add(Marker(
          markerId: MarkerId(panel.path),
          position: LatLng(panel.lat, panel.lon),
          icon: _pinLocationIcons[_themeIdentifier]));
    });
    return markers;
  }

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      _userLocation = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  // _getOSMClusters() async {
  //   List<SolarPanel> solarPanelData = await panelDatabase.getAllOSMPanelData();
  //   List<ClusterItem<MapPanel>> items = [];
  //   solarPanelData.forEach((panel) {
  //     items.add(ClusterItem(LatLng(panel.lat, panel.lon),
  //         item: MapPanel(userUploaded: false)));
  //   });
  //   setState(() {
  //     _clusterItems = items;
  //   });
  // }

  // _getMarkerData(LatLngBounds visibleRegion) async {
  //   List<Marker> markers = [];
  //   List<SolarPanel> solarPanelData =
  //       await panelDatabase.getOSMPanelData(visibleRegion);
  //   List<ClusterItem<MapPanel>> items = [];
  //   solarPanelData.forEach((panel) {
  //     items.add(ClusterItem(LatLng(panel.lat, panel.lon),
  //         item: MapPanel(userUploaded: false)));
  //   });
  //   _manager.setItems(items);
  // }

  _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // _manager.setMapController(controller);
    _mapController.setMapStyle(_mapStyles[_themeIdentifier]);
  }

  // _onCameraIdle() async {
  //   _getMarkerData(await _mapController.getVisibleRegion());
  //   _manager.updateMap();
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
                // onCameraMove: _manager.onCameraMove,
                // onCameraIdle: _onCameraIdle,
                markers: _markers,
                initialCameraPosition: _initialPostion,
              ),
            ),
    );
  }
}
