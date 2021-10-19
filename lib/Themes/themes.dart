// Defines Theme colors, Application font, and ChangeNotifier for
// changes to theme.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [ThemeData] for light theme colors and font
ThemeData lightTheme = ThemeData(
  // When using hex colours, replace # with 0xff in Color constructor
  // e.g. #150030 -> Color(0xff150030)
  colorScheme: ColorScheme(
    primary: const Color(0xfff97600),
    primaryVariant: const Color(0xfff45700),
    secondary: const Color(0xfff97600),
    secondaryVariant: const Color(0xfff45700),
    surface: const Color(0xffffc400),
    background: const Color(0xfffef1e0),
    error: const Color(0xfffc400),
    onPrimary: const Color(0xfffef1e0),
    onSecondary: const Color(0xfffef1e0),
    onSurface: const Color(0xfff45700),
    onBackground: const Color(0xff321d49),
    onError: const Color(0xfff76400),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

/// [ThemeData] for dark theme colors and font
ThemeData darkTheme = ThemeData(
  // When using hex colours, replace # with 0xff in Color constructor
  // e.g. #150030 -> Color(0xff150030)
  colorScheme: ColorScheme(
    primary: const Color(0xfff97600),
    primaryVariant: const Color(0xff150030),
    secondary: const Color(0xff22074c),
    secondaryVariant: const Color(0xff150030),
    surface: const Color(0xff22074c),
    background: const Color(0xff150030),
    error: const Color(0xff321d49),
    onPrimary: const Color(0xfffef1e0),
    onSecondary: const Color(0xffffffff),
    onSurface: const Color(0xfff45700),
    onBackground: const Color(0xfffef1e0),
    onError: const Color(0xfffef1e0),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.poppinsTextTheme()
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
);

/// Notifier for listeners listening to the selected themeMode
class SolarTheme with ChangeNotifier {
  static bool isDark = false;

  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  ThemeMode themeMode() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

SolarTheme solarTheme = SolarTheme();
