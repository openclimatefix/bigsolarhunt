import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:solar_hunt/DataStructs/mapillary_user.dart';
import 'package:solar_hunt/Services/mapillary_oauth.dart';
import 'package:solar_hunt/Services/mapillary_service.dart';
import 'package:solar_hunt/Services/markdown_services.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String backgroundImage =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? "assets/backgrounds/login-screen-background-light.png"
            : "assets/backgrounds/login-screen-background-dark.png";
    return WillPopScope(
        onWillPop: () => Navigator.of(context).pushNamed('/'),
        child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.asset(
                              'assets/branding/mapillary-logo.png')),
                      CreateAccountCard()
                    ]))));
  }
}

class CreateAccountCard extends StatelessWidget {
  const CreateAccountCard({
    Key key,
  }) : super(key: key);

  _continueWithoutAccount(BuildContext context) async {
    const _BEARER_TOKEN =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiI3ak9MM21JMVR4dThCUkU2em9laXVDIiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3pOVGxrTURFeU4yRTVZak0xTWpReCIsImlhdCI6MTYxMTU2OTk1OTQ5NCwianRpIjoiZjI4MjUyYWQ4NzNlZmM2YzczMzU3MTIyMGUwMjg3NjYiLCJzY28iOlsidXNlcjplbWFpbCIsInVzZXI6cmVhZCIsInB1YmxpYzp1cGxvYWQiXSwidmVyIjoxfQ.K_liNbNRshillMav_gAnaKv9RjWrAbrsJPLnHK5frWg';

    String userkey = JwtDecoder.decode(_BEARER_TOKEN)['sub'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('token', _BEARER_TOKEN);
    prefs.setBool('ownAccount', false);
    prefs.setString('userKey', userkey);

    Navigator.pushNamed(context, '/');
  }

  _createAccount(BuildContext context) async {
    OAuth2Client client = MapillaryOAuth2Client(
        customUriScheme: 'solar.streets.app',
        redirectUri: 'solar.streets.app://oauth2redirect');

    AccessTokenResponse tknResp = await client.getTokenWithImplicitGrantFlow(
        clientId: 'SG1nOGZNWEtmalFlN21JbFYxR2ltdDozNTlkMDEyN2E5YjM1MjQx',
        scopes: ['public:upload', 'user:email', 'user:read'],
        enableState: false);

    String userkey = JwtDecoder.decode(tknResp.accessToken)['sub'];

    MapillaryService mapillaryService = MapillaryService();
    MapillaryUser user = await mapillaryService.getUserFromKey(userkey);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.username);
    prefs.setString('token', tknResp.accessToken);
    prefs.setBool('ownAccount', true);
    prefs.setString('userKey', userkey);

    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BodyTextFromMdFile(mdfile: "assets/text/accountscreen.md"),
            ButtonBar(
                buttonAlignedDropdown: true,
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text("Let's go!"),
                      onPressed: () => _createAccount(context)),
                  OutlinedButton(
                      child: Text('Not now'),
                      onPressed: () => _continueWithoutAccount(context))
                ])
          ],
        ));
  }
}
