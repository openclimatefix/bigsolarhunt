import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bigsolarhunt/Screens/OnboardingScreen/onboarding_screen.dart';
import 'package:bigsolarhunt/home_page.dart';
import 'package:bigsolarhunt/Screens/UploadScreen/upload_screen.dart';
import 'package:bigsolarhunt/Themes/themes.dart';
import 'package:bigsolarhunt/Screens/AccountScreen/account_screen.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('userID');
  runApp(MyApp(userID: userID));
}

class MyApp extends StatefulWidget {
  final String userID;
  const MyApp({Key key, this.userID}) : super(key: key);

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
        initialRoute: widget.userID == null ? "/onboarding" : "/",
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
          '/onboarding': (context) => OnboardingScreen(),
          '/login': (context) => LoginScreen()
        },
        debugShowCheckedModeBanner: false);
  }
}
