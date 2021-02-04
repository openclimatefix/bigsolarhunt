import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_streets/DataStructs/mapillary_user.dart';
import 'package:solar_streets/Services/mapillary_oauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:solar_streets/Services/mapillary_service.dart';

class LoginScreen extends StatelessWidget {
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
    return WillPopScope(
        onWillPop: () => Navigator.of(context).pushNamed('/'),
        child: SafeArea(
            child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration:
                new BoxDecoration(color: Color.fromARGB(240, 255, 255, 255)),
          ),
          Positioned(
              top: -MediaQuery.of(context).size.height * 0.9,
              left: -MediaQuery.of(context).size.width * 0.5,
              child: Container(
                width: MediaQuery.of(context).size.width * 2,
                height: MediaQuery.of(context).size.height * 2,
                decoration: new BoxDecoration(
                  color: Color.fromARGB(240, 33, 43, 54),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.topCenter,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/mapillary-logo.png')),
              Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Create an account with Mapilliary?',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    textAlign: TextAlign.center,
                                  )),
                              Text(
                                'Mappilary is the service that processes and uploads submitted images to OpenStreetMap. Creating an account enables you to view your submissions on Mapillary\'s website.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              RaisedButton(
                                  child: Text('Create Account',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(color: Colors.white)),
                                  color: Color.fromARGB(240, 33, 43, 54),
                                  onPressed: () => _createAccount(context)),
                              OutlineButton(
                                  child: Text('Not now'),
                                  onPressed: () =>
                                      _continueWithoutAccount(context)),
                              Text('(You can change your mind later)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.grey))
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )
        ])));
  }
}
