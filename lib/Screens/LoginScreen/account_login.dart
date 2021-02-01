import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_streets/Services/mapillary_oauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatelessWidget {
  static const _BEARER_TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiI3ak9MM21JMVR4dThCUkU2em9laXVDIiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3pOVGxrTURFeU4yRTVZak0xTWpReCIsImlhdCI6MTYxMTU2OTk1OTQ5NCwianRpIjoiZjI4MjUyYWQ4NzNlZmM2YzczMzU3MTIyMGUwMjg3NjYiLCJzY28iOlsidXNlcjplbWFpbCIsInVzZXI6cmVhZCIsInB1YmxpYzp1cGxvYWQiXSwidmVyIjoxfQ.K_liNbNRshillMav_gAnaKv9RjWrAbrsJPLnHK5frWg';

  _continueWithoutAccount(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _BEARER_TOKEN);
    prefs.setBool('ownAccount', false);
    prefs.setString('userKey', JwtDecoder.decode(_BEARER_TOKEN)['sub']);
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', tknResp.accessToken);
    prefs.setBool('ownAccount', true);
    prefs.setString('userKey', JwtDecoder.decode(tknResp.accessToken)['sub']);
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
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
        ],
      ),
    );
  }
}
