import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bigsolarhunt/Screens/OnboardingScreen/onboarding_screen.dart';
import 'package:bigsolarhunt/home_page.dart';
import 'package:bigsolarhunt/Screens/UploadScreen/upload_screen.dart';
import 'package:bigsolarhunt/Themes/themes.dart';
import 'package:bigsolarhunt/Screens/LoginScreen/login_screen.dart';

int initScreen;

/// Entrypoint to application. Gets [SharedPreferences] instance to instantiate
/// application with awareness of current [userID].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userID = prefs.getString('userID');
  runApp(BigSolarHuntApp(userID: userID));
}

/// Top-level stateful widget. It's [build] function creates the [MaterialApp].
class BigSolarHuntApp extends StatefulWidget {
  final String userID;
  const BigSolarHuntApp({Key key, this.userID}) : super(key: key);

  @override
  _BigSolarHuntAppState createState() => _BigSolarHuntAppState();
}

class _BigSolarHuntAppState extends State<BigSolarHuntApp> {
  @override
  void initState() {
    super.initState();
    // Listen to changes in the theme mode.
    solarTheme.addListener(() {
      setState(() {});
    });
  }

  /// Instantiate MaterialApp instance, with dynamic theme, and defined route
  /// for each screen not found on the home screen's navigation bar.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: solarTheme.themeMode(),
        theme: lightTheme,
        darkTheme: darkTheme,
        // If the user does not yet have a set userID, show the onboarding
        // screen. Otherwise, go to the home page.
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
