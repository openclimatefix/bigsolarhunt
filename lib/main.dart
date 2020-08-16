import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';
import 'Screens/UploadScreen/upload_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            accentColor: Colors.teal,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
        },
        debugShowCheckedModeBanner: false);
  }
}
