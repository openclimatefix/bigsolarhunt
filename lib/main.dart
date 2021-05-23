import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:solar_hunt/Screens/OnboardingScreen/onboarding_screen.dart';
import 'package:solar_hunt/home_page.dart';
import 'package:solar_hunt/Screens/UploadScreen/upload_screen.dart';
import 'package:solar_hunt/Themes/themes.dart';
import 'package:solar_hunt/Screens/AccountScreen/account_screen.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const _BEARER_TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtcHkiLCJzdWIiOiI3ak9MM21JMVR4dThCUkU2em9laXVDIiwiYXVkIjoiU0cxbk9HWk5XRXRtYWxGbE4yMUpiRll4UjJsdGREb3pOVGxrTURFeU4yRTVZak0xTWpReCIsImlhdCI6MTYxMTU2OTk1OTQ5NCwianRpIjoiZjI4MjUyYWQ4NzNlZmM2YzczMzU3MTIyMGUwMjg3NjYiLCJzY28iOlsidXNlcjplbWFpbCIsInVzZXI6cmVhZCIsInB1YmxpYzp1cGxvYWQiXSwidmVyIjoxfQ.K_liNbNRshillMav_gAnaKv9RjWrAbrsJPLnHK5frWg';
  String userkey = JwtDecoder.decode(_BEARER_TOKEN)['sub'];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', "");
  prefs.setString('token', _BEARER_TOKEN);
  prefs.setBool('ownAccount', false);
  prefs.setString('userKey', userkey);
  String token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatefulWidget {
  final String token;
  const MyApp({Key key, this.token}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    solarTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: solarTheme.themeMode(),
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: widget.token == null ? "/onboarding" : "/",
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
          '/onboarding': (context) => OnboardingScreen(),
          '/login': (context) => LoginScreen()
        },
        debugShowCheckedModeBanner: true);
  }
}
