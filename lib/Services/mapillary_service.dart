import 'dart:io';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:solar_streets/DataStructs/solar_panel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:solar_streets/DataStructs/upload_queue_item.dart';
import 'package:solar_streets/Services/database_services.dart';
import 'dart:convert';

class MapillaryService {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;

  static const _BASE_URL = 'https://a.mapillary.com/v3/me/uploads';
  static const _BEARER_TOKEN =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiJIbWc4Zk1YS2ZqUWU3bUlsVjFHaW10IiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3hPREpoWmpneU1XSm1NRFZtT0dRMSIsImlhdCI6MTU5OTY2NDMyODA2OSwianRpIjoiNmViY2M4MDg0NTFkM2U5ZmI1ZmY1ZjZmMWNlYjZhMjIiLCJzY28iOlsicHVibGljOnVwbG9hZCJdLCJ2ZXIiOjF9.sZxR1YJHMeKzNeWqobvowL_xZRGM9uBcKoWdBwwJh6c';
  static const _CLIENT_ID =
      'SG1nOGZNWEtmalFlN21JbFYxR2ltdDoxODJhZjgyMWJmMDVmOGQ1';

  Future<bool> upload(File imageFile, LatLng panelLocation) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final UploadSession session = await _createUploadSession();
      // TODO: add location to upload
      await _awsUpload(imageFile, session);
      await uploadQueuePanels(session);
      await _closeUploadSession(session);
      await panelDatabase.insertUserPanel(SolarPanel(
          id: null, lat: panelLocation.latitude, lon: panelLocation.longitude));
      return true;
    } else {
      panelDatabase.insertQueueData(imageFile.path, panelLocation);
      return false;
    }
  }

  Future uploadQueuePanels(UploadSession session) async {
    final List<UploadQueueItem> uploadQueue =
        await panelDatabase.getUploadQueue();
    uploadQueue.forEach((uploadQueueItem) async {
      final File image = File(uploadQueueItem.path);
      await _awsUpload(image, session);
      panelDatabase.deleteFromUploadQueue(uploadQueueItem);
      panelDatabase.insertUserPanel(SolarPanel(
          id: null, lat: uploadQueueItem.lat, lon: uploadQueueItem.lon));
    });
  }

  Future<UploadSession> _createUploadSession() async {
    final String url = _BASE_URL + '?client_id=$_CLIENT_ID';
    final Map<String, String> headers = {};
    final Map<String, String> body = {};
    headers['Authorization'] = _BEARER_TOKEN;
    headers['Content-Type'] = 'application/json';
    body['type'] = 'images/sequence';
    final response =
        await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      final session = UploadSession.fromJson(jsonDecode(response.body));
      return session;
    } else {
      throw MapillaryException('Error creating session');
    }
  }

  Future<File> _awsUpload(File image, UploadSession session) async {
    String fileName = image.path.split("/").last;
    final fields = session.fields;
    fields['key'] = session.keyPrefix + fileName;
    final stream = http.ByteStream((image.openRead()));
    stream.cast();
    final length = await image.length();
    final uri = Uri.parse(session.url);
    final request = http.MultipartRequest("POST", uri);
    final multipartFile =
        http.MultipartFile('file', stream, length, filename: fileName);
    request.files.add(multipartFile);
    fields.forEach((key, value) {
      request.fields[key] = value;
    });
    final response = await request.send();
    if (response.statusCode == 204) {
      return image;
    } else {
      print('Error uploading');
      throw Exception('Error uploading to AWS');
    }
  }

  _closeUploadSession(UploadSession session) async {
    final String url = _BASE_URL +
        '/${session.key}/closed?client_id=$_CLIENT_ID&_dry_run'; //TODO remove &_dry_run to publish for reals
    final Map<String, String> headers = {};
    headers['Authorization'] = _BEARER_TOKEN;
    final response = await http.put(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error publishing session');
    }
  }
}

class UploadSession {
  UploadSession({this.fields, this.key, this.keyPrefix, this.url});

  final Map<String, dynamic> fields;
  final String key;
  final String keyPrefix;
  final String url;

  factory UploadSession.fromJson(Map<String, dynamic> json) => UploadSession(
      fields: json['fields'],
      key: json['key'],
      keyPrefix: json['key_prefix'],
      url: json['url']);
}

class MapillaryException implements Exception {
  final _message;
  MapillaryException(this._message);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}
