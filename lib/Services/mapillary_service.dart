// Service for communicating with Mapillary's API for image upload.
// This is currently unused, as telegram was a workaround, but is left here
// incase the code can be reused for Mapillary API v4.

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bigsolarhunt/DataStructs/solar_panel.dart';
import 'package:bigsolarhunt/Services/database_services.dart';
import 'package:bigsolarhunt/Services/telegram_service.dart';
import 'package:bigsolarhunt/Config/config.dart';

import 'dart:convert';

/// Service for posting to Mapillary's API, including methods
/// for creating and closing sessions, and uploading both individual
/// and multiple images via POST
class MapillaryService {
  String userEmail;
  DatabaseProvider panelDatabase = DatabaseProvider.databaseProvider;
  final TelegramBot telegramBot = TelegramBot();

  /// upload attempts to upload a SolarPanel struct to Mapillary
  /// returns true if successful, else false
  Future<bool> upload(SolarPanel newPanel) async {
    final UploadSession session = await _createUploadSession();
    final imageFile = File(newPanel.path);
    try {
      await _uploadImageWithSession(imageFile, session);
      await _closeUploadSession(session);
      await uploadQueuePanels();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  /// uploadQueuePanels attempts to upload all the panel images
  /// in the panel table database who's uploaded column is zero.
  /// Returns true on success or false otherwise.
  Future<bool> uploadQueuePanels() async {
    final UploadSession session = await _createUploadSession();
    final List<SolarPanel> uploadQueue = await panelDatabase.getUploadQueue();
    try {
      uploadQueue.forEach((uploadQueuePanel) async {
        final File image = File(uploadQueuePanel.path);
        await _uploadImageWithSession(image, session);
        panelDatabase.markAsUploaded(uploadQueuePanel);
      });
      await _closeUploadSession(session);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  /// _createUploadSession osts to the Mapillary API to
  /// fetch an [UploadSession] Authorization struct
  Future<UploadSession> _createUploadSession() async {
    final Uri url = Uri.parse(
        '${Env.MAPILLARY_BASE_URL}?client_id=${Env.MAPILLARY_CLIENT_ID}');

    // Post to Mapillary API requesting session creation
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Env.MAPILLARY_BEARER_TOKEN}',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: {
          json.encode({'type': 'images/sequence'}),
        }
    );

    if (response.statusCode == 200) {
      final session = UploadSession.fromJson(jsonDecode(response.body));
      return session;
    } else {
      throw MapillaryException('Error creating session');
    }
  }

  /// _uploadImageWithSession posts a file to the Mapillary API,
  /// using the input UploadSession for auth
  Future<File> _uploadImageWithSession(File image, UploadSession session) async {
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
      throw Exception('Error uploading to Mapillary');
    }
  }

  /// _closeUploadSession posts to the Mapillary API
  /// to close the input [UploadSession]
  _closeUploadSession(UploadSession session) async {
    final Uri url = Uri.parse(Env.MAPILLARY_BASE_URL +
        '/${session.key}/closed?client_id=' +
        Env.MAPILLARY_CLIENT_ID);
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer ' + Env.MAPILLARY_BEARER_TOKEN;
    final response = await http.put(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error closing session');
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

/// UploadSession is a wrapper class for handling JSON response
/// from Mapillary session creation REST call as a class Object
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

/// MapillaryException wraps an exception JSON response as a class
class MapillaryException implements Exception {
  final _message;
  MapillaryException(this._message);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}
