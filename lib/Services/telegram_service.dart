// Service for writing data to telegram. This is a workaround whilst
// Mapillary is updating it's API.

import 'dart:io';

import 'package:bigsolarhunt/DataStructs/solar_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'package:bigsolarhunt/Config/config.dart';

/// Service for posting to Telegram's API
class TelegramBot {
  var teledart = TeleDart(Telegram(Env.TELEGRAM_BOT_TOKEN), Event("Bot"));

  /// Sends message to telegram channel informing of new user
  newUser({String userID, String email}) {
    var message = "userID: $userID\nemail: $email";
    teledart.telegram.sendMessage(Env.TELEGRAM_CHAT_ID, message);
  }

  /// Sends new panel image to telegram channel
  Future<bool> userUpload(SolarPanel newPanel) async {
    String email = await _getEmail();
    String userID = await _getUserID();
    final lat = newPanel.lat;
    final lon = newPanel.lon;
    var message = "userID: $userID, email: $email, lat: $lat, lon: $lon";

    final image = File(newPanel.path);
    try {
      await teledart.telegram
          .sendPhoto(Env.TELEGRAM_CHAT_ID, image, caption: message);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
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
