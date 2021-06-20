import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'package:bigsolarhunt/Config/config.dart';

class TelegramBot {
  var teledart = TeleDart(Telegram(Env.TELEGRAM_BOT_TOKEN), Event());

  newUser({String userID, String email}) {
    var message = "userID: $userID\nemail: $email";
    teledart.telegram.sendMessage(Env.TELEGRAM_CHAT_ID, message);
  }

  userUpload({String userID, String email, String imageKey}) {
    var message = "userID: $userID\nemail: $email\nimageKey: $imageKey";
    teledart.telegram.sendMessage(Env.TELEGRAM_CHAT_ID, message);
  }
}
