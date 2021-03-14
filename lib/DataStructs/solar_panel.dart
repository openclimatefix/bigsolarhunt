class SolarPanel {
  SolarPanel({this.id, this.lat, this.lon, this.date});

  final int id;
  final double lat;
  final double lon;
  final DateTime date;

  factory SolarPanel.fromMap(Map<String, dynamic> json) => new SolarPanel(
      id: json['id'],
      lat: json['lat'],
      lon: json['lon'],
      date: json['date'] == 'NULL' ? null : DateTime.parse(json['date']));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'date': date == null ? 'NULL' : date.toIso8601String()
    };
  }

  Map<String, dynamic> toMapNoID() {
    return {
      'lat': lat,
      'lon': lon,
      'date': date == null ? 'NULL' : date.toIso8601String()
    };
  }
}
