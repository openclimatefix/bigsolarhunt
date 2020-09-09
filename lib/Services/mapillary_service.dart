import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapillaryService {
  static const _BASE_URL = 'https://a.mapillary.com/v3/me/uploads';
  static const _BEARER_TOKEN =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiJBUWdDaUl6VUlMSDVlWmFMZDFqbG1PIiwiYXVkIjoiYUVGWVdFeDRUMWRTUVdwWk9HVm9aVVpHZG13M2JUcGlOems1TUdVMk1qQTJaR1kxTnpneSIsImlhdCI6MTU5NzA1OTAxODU0NCwianRpIjoiMWEyOTY2Mjc2M2NiZDEzNWE3MTAxNjg5YjEzNmZhMjkiLCJzY28iOlsicHVibGljOnVwbG9hZCIsInByaXZhdGU6cmVhZCIsInByaXZhdGU6dXBsb2FkIl0sInZlciI6MX0.mOggY3udqDRSTKVYr-RF06K4iF6zfl5Yyjq1WRjWmrE'; //TODO update (maybe fetch) token
  static const _CLIENT_ID =
      'aEFYWEx4T1dSQWpZOGVoZUZGdmw3bTpiNzk5MGU2MjA2ZGY1Nzgy'; // TODO update client_id

  Future<File> upload(File imageFile) async {
    final UploadSession session = await _createUploadSession();
    final File uploadedFile = await _awsUpload(imageFile, session);
    await _closeUploadSession(session);
    return uploadedFile;
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
      throw Exception('Error creating session');
    }
  }

  Future<File> _awsUpload(File image, UploadSession session) async {
    String fileName = image.path.split("/").last;
    final fields = session.fields;
    fields['key'] = session.key_prefix + fileName;
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
  UploadSession({this.fields, this.key, this.key_prefix, this.url});

  final Map<String, dynamic> fields;
  final String key;
  final String key_prefix;
  final String url;

  factory UploadSession.fromJson(Map<String, dynamic> json) => UploadSession(
      fields: json['fields'],
      key: json['key'],
      key_prefix: json['key_prefix'],
      url: json['url']);
}
