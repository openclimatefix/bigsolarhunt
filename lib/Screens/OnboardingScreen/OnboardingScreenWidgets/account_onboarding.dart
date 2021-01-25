import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_streets/Services/mapillary_oauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OnboardingAccount extends StatelessWidget {
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: 'create',
              label: Text('       Create an account       '),
              onPressed: () => _createAccount(context),
            ),
            SizedBox(height: 70),
            FloatingActionButton.extended(
              heroTag: 'continue',
              label: Text('Continue without an account'),
              onPressed: () => _continueWithoutAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
