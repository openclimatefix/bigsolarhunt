import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  accentColor: Colors.orange[400],
  navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Color.fromARGB(255, 234, 234, 234)),
  iconTheme: IconThemeData(color: Colors.black54),
  textTheme: GoogleFonts.interTextTheme(),
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.orange[400],
    navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Color.fromARGB(255, 29, 29, 29)),
    iconTheme: IconThemeData(color: Colors.white60),
    textTheme: GoogleFonts.interTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white));

/*
-----flutter stable channel-----
// LIGHT THEME
bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 234, 234, 234)),

// DARK THEME
bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 29, 29, 29)),
*/
