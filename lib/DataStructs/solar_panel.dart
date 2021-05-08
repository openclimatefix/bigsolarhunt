class SolarPanel {
  SolarPanel(
      {this.id, this.lat, this.lon, this.path, this.date, this.uploaded});

  final int id;
  final double lat;
  final double lon;
  final String path;
  final DateTime date;
  final bool uploaded;

  factory SolarPanel.fromMap(Map<String, dynamic> json) => new SolarPanel(
      id: json['id'],
      lat: json['lat'],
      lon: json['lon'],
      path: json['path'],
      date: json['date'] == 'NULL' ? null : DateTime.parse(json['date']),
      uploaded: json['uploaded'] == 1);

  Map<String, dynamic> toMapNoID({bool setUploaded = true}) {
    return {
      'lat': lat,
      'lon': lon,
      'path': path,
      'date': date == null ? 'NULL' : date.toIso8601String(),
      'uploaded': setUploaded ? 1 : 0
    };
  }
}
