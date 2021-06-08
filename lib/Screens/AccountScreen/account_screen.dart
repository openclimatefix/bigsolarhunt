import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:solar_hunt/Services/markdown_services.dart';
import 'package:solar_hunt/Services/telegram_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.background,
              ],
              stops: [0.0, 0.4, 0.4, 1.0],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
          child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child:
                            Image.asset('assets/branding/possible-logo.jpg')),
                    CreateAccountCard(),
                  ]))),
    );
  }
}

class CreateAccountCard extends StatelessWidget {
  CreateAccountCard({
    Key key,
  }) : super(key: key);
  static const _BEARER_TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiJIbWc4Zk1YS2ZqUWU3bUlsVjFHaW10IiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3pOVGxrTURFeU4yRTVZak0xTWpReCIsImlhdCI6MTYxMTU2ODgwNjQyMCwianRpIjoiNDA0M2MzODBhNDg2ODkyNzM1ODAyMzE3ZGJlYzc0YjEiLCJzY28iOlsidXNlcjplbWFpbCIsInVzZXI6cmVhZCIsInB1YmxpYzp1cGxvYWQiXSwidmVyIjoxfQ.txc1ozeSpYyQ7Zt_RspHFnE_LvyTqUqvvdh3OfLeoG0';

  final TelegramBot telegramBot = TelegramBot();
  final textController = TextEditingController();

  _continueWithoutAccount(BuildContext context) async {
    String userkey = JwtDecoder.decode(_BEARER_TOKEN)['sub'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _BEARER_TOKEN);
    prefs.setString('userKey', userkey);
    prefs.setString('email', null);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  _createAccount(BuildContext context) async {
    String userkey = JwtDecoder.decode(_BEARER_TOKEN)['sub'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = textController.text;
    prefs.setString('token', _BEARER_TOKEN);
    prefs.setString('userKey', userkey);
    prefs.setString('email', email);
    telegramBot.newUser(email);
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BodyTextFromMdFile(mdfile: "assets/text/accountscreen.md"),
            Card(
                child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Enter your email',
              ),
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
            Padding(
              padding: EdgeInsets.only(bottom: bottom),
            )
          ],
        ));
  }
}
