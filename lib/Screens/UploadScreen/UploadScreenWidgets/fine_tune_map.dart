import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class FineTuneMap extends StatefulWidget {
  const FineTuneMap({Key key}) : super(key: key);

  @override
  _FineTuneMapState createState() => _FineTuneMapState();
}

class _FineTuneMapState extends State<FineTuneMap> {
  Location location = new Location();
  static String _tileUrl;
  static LatLng _userLocation;
  static LatLng _userLocationUpperBound;
  static LatLng _userLocationLowerBound;
  static List<Marker> _markers = [];
  static LatLng _panelLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _getUserLocation() async {
    LocationData locationData = await location.getLocation();
    if (!mounted) return;
    setState(() {
      _userLocation = LatLng(locationData.latitude, locationData.longitude);
      _panelLocation = LatLng(locationData.latitude, locationData.longitude);
      _userLocationUpperBound = LatLng(
          locationData.latitude + 0.0007, locationData.longitude + 0.0008);
      _userLocationLowerBound = LatLng(
          locationData.latitude - 0.0007, locationData.longitude - 0.0008);
    });
  }

  _updatePostion(MapPosition mapPosition, bool boolValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _panelLocation = mapPosition.center;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _tileUrl = Theme.of(context).brightness == Brightness.light
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
        : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';

    Image _uploadMarker = Image.asset('assets/icons/panel-icon-queue.png');

    _markers = [
      Marker(
          point: _panelLocation,
          builder: (ctx) => Container(child: _uploadMarker))
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit location',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.done),
                onPressed: () => Navigator.pop(context, _panelLocation))
          ],
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: Stack(children: <Widget>[
          new FlutterMap(
            options: MapOptions(
                center: _userLocation,
                zoom: 18,
                minZoom: 17,
                maxZoom: 18,
                swPanBoundary: _userLocationLowerBound,
                nePanBoundary: _userLocationUpperBound,
                onPositionChanged: (mapPosition, boolValue) =>
                    {_updatePostion(mapPosition, boolValue)}),
            layers: [
              TileLayerOptions(
                urlTemplate: _tileUrl,
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: _markers),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryVariant),
              alignment: Alignment.topCenter,
              child: Center(
                  child: Text("Drag the map to position the marker",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                      textAlign: TextAlign.center)))
        ]));
  }
}
