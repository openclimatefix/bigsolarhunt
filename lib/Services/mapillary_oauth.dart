import 'package:flutter/widgets.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class MapillaryOAuth2Client extends OAuth2Client {
  MapillaryOAuth2Client(
      {@required String redirectUri, @required String customUriScheme})
      : super(
            authorizeUrl: 'https://www.mapillary.com/connect',
            tokenUrl: 'https://a.mapillary.com/v2/oauth/authorize',
            redirectUri: redirectUri,
            customUriScheme: customUriScheme) {
    this.accessTokenRequestHeaders = {'Accept': 'applicaiton/json'};
  }

  @override
  Future<AccessTokenResponse> getTokenWithImplicitGrantFlow({
    @required String clientId,
    List<String> scopes,
    bool enableState = true,
    String state,
    httpClient,
    webAuthClient,
  }) async {
    httpClient ??= http.Client();
    webAuthClient ??= this.webAuthClient;

    final authorizeUrl = getAuthorizeUrl(
        clientId: clientId,
        responseType: 'token',
        scopes: scopes,
        enableState: enableState,
        state: state,
        redirectUri: redirectUri);

    // Present the dialog to the user
    final result = await webAuthClient.authenticate(
        url: authorizeUrl, callbackUrlScheme: customUriScheme);

    final fragment = Uri.parse(result).queryParameters;

    return AccessTokenResponse.fromMap({
      'access_token': fragment['access_token'],
      'token_type': fragment['token_type'],
      'scope': fragment['scope'] ?? scopes,
      'http_status_code': 200
    });
  }
}
