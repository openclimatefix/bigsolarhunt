import 'dart:convert';

class SolarPanel {
  SolarPanel({this.id, this.lat, this.lon});

  final int id;
  final double lat;
  final double lon;

  factory SolarPanel.fromJson(Map<String, dynamic> json) =>
      SolarPanel(id: json['id'], lat: json['lat'], lon: json['lon']);

  static Map<String, dynamic> toMap(SolarPanel solarPanel) =>
      {'id': solarPanel.id, 'lat': solarPanel.lat, 'lon': solarPanel.lon};

  static String encodeSolarPanels(List<SolarPanel> solarPanels) => json.encode(
        solarPanels
            .map<Map<String, dynamic>>(
                (solarPanel) => SolarPanel.toMap(solarPanel))
            .toList(),
      );

  static List<SolarPanel> decodeSolarPanels(String solarPanels) =>
      (json.decode(solarPanels) as List<dynamic>)
          .map<SolarPanel>((item) => SolarPanel.fromJson(item))
          .toList();

  static String encodeSolarPanelsMap(Map<int, SolarPanel> solarPanelsMap) {
    final List<SolarPanel> updatedPanelList = [];
    solarPanelsMap.forEach((key, value) {
      updatedPanelList.add(value);
    });
    return SolarPanel.encodeSolarPanels(updatedPanelList);
  }
}
