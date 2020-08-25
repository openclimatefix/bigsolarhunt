import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../Model/solar_panel.dart';

class OSMService {
  static const String _panelDataFilename = 'osm_panel_data.txt';
  static const List<String> _osmBaseURL = [
    'http://overpass-api.de/api/interpreter?data=[out:json];node["generator:source"="solar"]["location"="roof"](newer:"',
    'Z")(49.92,-10.6,61.02,1.935);out;'
  ];

  static const Duration _updateTime = Duration(hours: 1);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _panelDataFile async {
    final path = await _localPath;
    return File('$path/$_panelDataFilename');
  }

  Future<Map<int, SolarPanel>> _getNewerData(DateTime lastUpdated) async {
    final String url =
        _osmBaseURL[0] + lastUpdated.toIso8601String() + _osmBaseURL[1];
    final response = await http.get(url);
    final responseData = jsonDecode(response.body)['elements'];
    final Map<int, SolarPanel> panelData = {};
    responseData
        .map((panel) => SolarPanel.fromJson(panel))
        .forEach((solarPanel) => panelData[solarPanel.id] = solarPanel);
    return panelData;
  }

  _getInitialPanelData(File file) async {
    final Map<int, SolarPanel> panelData = await _getNewerData(DateTime(2000));
    await file.writeAsString(SolarPanel.encodeSolarPanelsMap(panelData));
  }

  updatePanelData() async {
    final file = await _panelDataFile;
    final fileExists = await file.exists();
    if (!fileExists) {
      await _getInitialPanelData(file);
    } else {
      final DateTime lastUpdated = await file.lastModified();
      final Duration timeDifference = DateTime.now().difference(lastUpdated);

      if (timeDifference > _updateTime) {
        final Map<int, SolarPanel> newPanelData =
            await _getNewerData(lastUpdated);
        final List<SolarPanel> oldPanelData =
            SolarPanel.decodeSolarPanels(await file.readAsString());
        final Map<int, SolarPanel> updatedPanelData = {};
        oldPanelData.forEach(
            (solarPanel) => updatedPanelData[solarPanel.id] = solarPanel);
        newPanelData.forEach((key, value) {
          updatedPanelData[key] = value;
        });

        file.writeAsString(SolarPanel.encodeSolarPanelsMap(updatedPanelData));
      }
    }
  }

  Future<List<SolarPanel>> getPanelData() async {
    try {
      final panelDataFile = await _panelDataFile;
      return SolarPanel.decodeSolarPanels(await panelDataFile.readAsString());
    } catch (e) {
      throw Exception('Error reading panel data file');
    }
  }
}
