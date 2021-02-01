import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:solar_streets/Screens/OnboardingScreen/onboarding_screen.dart';
import 'package:solar_streets/home_page.dart';
import 'package:solar_streets/Screens/UploadScreen/upload_screen.dart';
import 'package:solar_streets/Themes/themes.dart';
import 'Screens/LoginScreen/account_login.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String token;
  MyApp({
    this.token,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: token == null ? "onboarding" : "/",
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
          'onboarding': (context) => OnboardingScreen(),
          'login': (context) => LoginScreen()
        },
        debugShowCheckedModeBanner: false);
  }
}
