import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:solar_streets/Screens/OnboardingScreen/onboarding_screen.dart';
import 'package:solar_streets/home_page.dart';
import 'package:solar_streets/Screens/UploadScreen/upload_screen.dart';
import 'package:solar_streets/Themes/themes.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute:
            initScreen == 0 || initScreen == null ? "onboarding" : "/",
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
          'onboarding': (context) => OnboardingScreen(),
        },
        debugShowCheckedModeBanner: false);
  }
}
