import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: const Color(0xff6200ee),
    primaryVariant: const Color(0xff3700b3),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff018786),
    surface: Colors.white,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: const Color(0xffbb86fc),
    primaryVariant: const Color(0xff3700B3),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff03dac6),
    surface: const Color(0xff1d1d1d),
    background: const Color(0xff121212),
    error: const Color(0xffcf6679),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.poppinsTextTheme()
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
);
