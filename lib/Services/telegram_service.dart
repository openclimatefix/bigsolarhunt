import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot {
  static const _BOT_TOKEN = '1819046324:AAGX3fUFtSWlkkCFcXRTPfSqpD1J-1ZQYt4';
  static const _CHAT_ID = '1373362016';
  var teledart = TeleDart(Telegram(_BOT_TOKEN), Event());

  newUser(String email) {
    teledart.telegram.sendMessage(_CHAT_ID, email);
  }

  userUpload(String email, String imageKey) {
    var uploadMessage = '$email image_key: $imageKey';
    teledart.telegram.sendMessage(_CHAT_ID, uploadMessage);
  }
}
