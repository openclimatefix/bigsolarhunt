import 'dart:convert';

class SolarPanel {
  SolarPanel({this.id, this.lat, this.lon});

  final int id;
  final double lat;
  final double lon;

  factory SolarPanel.fromMap(Map<String, dynamic> json) =>
      new SolarPanel(id: json['id'], lat: json['lat'], lon: json['lon']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'lat': lat, 'lon': lon};
  }
}
