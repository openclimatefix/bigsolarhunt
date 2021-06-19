import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:solar_hunt/Services/markdown_services.dart';
import 'package:solar_hunt/Services/telegram_service.dart';

class LoginScreen extends StatefulWidget {
  static const _BEARER_TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiJIbWc4Zk1YS2ZqUWU3bUlsVjFHaW10IiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3pOVGxrTURFeU4yRTVZak0xTWpReCIsImlhdCI6MTYxMTU2ODgwNjQyMCwianRpIjoiNDA0M2MzODBhNDg2ODkyNzM1ODAyMzE3ZGJlYzc0YjEiLCJzY28iOlsidXNlcjplbWFpbCIsInVzZXI6cmVhZCIsInB1YmxpYzp1cGxvYWQiXSwidmVyIjoxfQ.txc1ozeSpYyQ7Zt_RspHFnE_LvyTqUqvvdh3OfLeoG0';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TelegramBot telegramBot = TelegramBot();

  final textController = TextEditingController();

  _continueWithoutAccount(BuildContext context) async {
    String userkey = JwtDecoder.decode(LoginScreen._BEARER_TOKEN)['sub'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', LoginScreen._BEARER_TOKEN);
    prefs.setString('userKey', userkey);
    prefs.setString('email', null);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  _createAccount(BuildContext context) async {
    String userkey = JwtDecoder.decode(LoginScreen._BEARER_TOKEN)['sub'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = textController.text;
    prefs.setString('token', LoginScreen._BEARER_TOKEN);
    prefs.setString('userKey', userkey);
    prefs.setString('email', email);
    telegramBot.newUser(email);
    Navigator.of(context).pushNamed('/');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset('assets/branding/possible-logo.jpg')),
              BodyTextFromMdFile(mdfile: "assets/text/accountscreen.md"),
              Card(
                  child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Enter your email',
                ),
                validator: (String value) {
                  return (value == "" ||
                          !value.contains(".") ||
                          !value.contains("@") ||
                          value.split("@").last.length < 1 ||
                          value.split(".").last.length < 2 ||
                          value.length < 6)
                      ? 'Enter a valid email'
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: textController,
              )),
              ButtonBar(
                  buttonAlignedDropdown: false,
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text("Let's go!"),
                        onPressed: () => _createAccount(context)),
                    SizedBox(width: 200),
                    TextButton(
                        child: Text('No thanks.'),
                        onPressed: () => _continueWithoutAccount(context)),
                  ]),
              SizedBox(height: 30),
              SelectableText("Privacy policy", onTap: () {
                launch("https://www.wearepossible.org/legalcookies");
              })
            ])));
  }
}
