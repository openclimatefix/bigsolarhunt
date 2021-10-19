/// Defines dart variables that are populated at buildtime via environment
/// variables. To add a new variable simply append a new [static const] to the
/// class. These can then be passed in as [dart-define] parameters to the
/// flutter build command.
///
/// To access an env var in dart code, add
///
/// [import 'package:bigsolarhunt/Config/config.dart';]
///
/// to the import section and then access the variable via
///
/// [Env.variableName]
class Env {
  static const MAPILLARY_BEARER_TOKEN =
      String.fromEnvironment('MAPILLARY_BEARER_TOKEN');
  // See https://github.com/mapillary/mapillary_tools/blob/master/mapillary_tools/upload_api_v4.py
  static const MAPILLARY_BASE_URL = 'https://rupload.facebook.com/mapillary_public_uploads';
  static const MAPILLARY_CLIENT_ID =
      String.fromEnvironment('MAPILLARY_CLIENT_ID');
  static const TELEGRAM_BOT_TOKEN =
      String.fromEnvironment('TELEGRAM_BOT_TOKEN');
  static const TELEGRAM_CHAT_ID = String.fromEnvironment('TELEGRAM_CHAT_ID');
}
