class UploadQueueItem {
  UploadQueueItem({this.path, this.lat, this.lon});

  final String path;
  final double lat;
  final double lon;

  Map<String, dynamic> toMap() {
    return {'path': path, 'lat': lat, 'lon': lon};
  }

  factory UploadQueueItem.fromMap(Map<String, dynamic> json) =>
      new UploadQueueItem(
          path: json['path'], lat: json['lat'], lon: json['lon']);
}
