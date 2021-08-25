import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bigsolarhunt/DataStructs/solar_panel.dart';
import 'package:bigsolarhunt/Services/database_services.dart';
import 'package:bigsolarhunt/Services/telegram_service.dart';
import 'package:bigsolarhunt/Config/config.dart';

import 'dart:convert';

class MapillaryService {
  String userEmail;
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  final TelegramBot telegramBot = TelegramBot();

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
    final Uri url = Uri.parse(
        Env.MAPILLARY_BASE_URL + '?client_id=' + Env.MAPILLARY_CLIENT_ID);
    final Map<String, String> headers = {};
    final Map<String, String> body = {};
    headers['Authorization'] = 'Bearer ' + Env.MAPILLARY_BEARER_TOKEN;
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
      Future<String> email = _getEmail();
      Future<String> userID = _getUserID();
      String imageKey = response.headers['location'].split('%2F')[4];
      return image;
    } else {
      throw Exception('Error uploading to AWS');
    }
  }

  _closeUploadSession(UploadSession session) async {
    final Uri url = Uri.parse(Env.MAPILLARY_BASE_URL +
        '/${session.key}/closed?client_id=' +
        Env.MAPILLARY_CLIENT_ID);
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer ' + Env.MAPILLARY_BEARER_TOKEN;
    final response = await http.put(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error publishing session');
    }
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    return email;
  }

  Future<String> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID');
    return userID;
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
