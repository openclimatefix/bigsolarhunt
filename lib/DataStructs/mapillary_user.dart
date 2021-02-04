class MapillaryUser {
  MapillaryUser({this.key, this.username, this.avatar});

  final String key;
  final String username;
  final String avatar;

  factory MapillaryUser.fromJson(Map<String, dynamic> json) => MapillaryUser(
      key: json['key'], username: json['username'], avatar: json['avatar']);
}
