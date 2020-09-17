class UploadQueue {
  UploadQueue({this.path, this.lat, this.lon});

  final String path;
  final double lat;
  final double lon;

  Map<String, dynamic> toMap() {
    return {'path': path, 'lat': lat, 'lon': lon};
  }
}
