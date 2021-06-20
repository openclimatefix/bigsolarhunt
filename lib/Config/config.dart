class Env {
  static const MAPILLARY_BEARER_TOKEN =
      String.fromEnvironment('MAPILLARY_BEARER_TOKEN');
  static const MAPILLARY_BASE_URL = 'https://a.mapillary.com/v3/me/uploads';
  static const MAPILLARY_CLIENT_ID =
      String.fromEnvironment('MAPILLARY_CLIENT_ID');
  static const TELEGRAM_BOT_TOKEN =
      String.fromEnvironment('TELEGRAM_BOT_TOKEN');
  static const TELEGRAM_CHAT_ID = String.fromEnvironment('TELEGRAM_CHAT_ID');
}
