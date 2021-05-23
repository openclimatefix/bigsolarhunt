import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_hunt/DataStructs/mapillary_user.dart';
import 'package:solar_hunt/DataStructs/solar_panel.dart';
import 'package:solar_hunt/Services/database_services.dart';
import 'dart:convert';

class MapillaryService {
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;

  static const _BASE_URL = 'https://a.mapillary.com/v3/me/uploads';
  static const _CLIENT_ID =
      'SG1nOGZNWEtmalFlN21JbFYxR2ltdDozNTlkMDEyN2E5YjM1MjQx';

  Future<bool> upload(SolarPanel newPanel) async {
    // upload attempts to upload a SolarPanel struct to Mapillary
    // returns true if succesful, else false
    final UploadSession session = await _createUploadSession();
    final imageFile = File(newPanel.path);
    try {
      await _awsUpload(imageFile, session);
      await _closeUploadSession(session);
      await uploadQueuePanels();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> uploadQueuePanels() async {
    final UploadSession session = await _createUploadSession();
    final List<SolarPanel> uploadQueue = await panelDatabase.getUploadQueue();
    try {
      uploadQueue.forEach((uploadQueuePanel) async {
        final File image = File(uploadQueuePanel.path);
        await _awsUpload(image, session);
        panelDatabase.markAsUploaded(uploadQueuePanel);
      });
      await _closeUploadSession(session);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<UploadSession> _createUploadSession() async {
    final Uri url = Uri.parse(_BASE_URL + '?client_id=$_CLIENT_ID');
    final Map<String, String> headers = {};
    final Map<String, String> body = {};
    final String token = await _getToken();
    headers['Authorization'] = token;
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
      throw Exception('Error uploading to AWS');
    }
  }

  _closeUploadSession(UploadSession session) async {
    final Uri url =
        Uri.parse(_BASE_URL + '/${session.key}/closed?client_id=$_CLIENT_ID');
    final Map<String, String> headers = {};
    final String token = await _getToken();
    headers['Authorization'] = token;
    final response = await http.put(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error publishing session');
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return 'Bearer ' + token;
  }

  Future<MapillaryUser> getUserFromKey(String userkey) async {
    var clientId = 'SG1nOGZNWEtmalFlN21JbFYxR2ltdDozNTlkMDEyN2E5YjM1MjQx';

    var url = Uri.parse(
        'https://a.mapillary.com/v3/users/$userkey?client_id=$clientId');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var user = MapillaryUser.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Error getting user');
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
