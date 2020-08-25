import 'package:flutter/material.dart';

import 'home_page.dart';
import 'Screens/UploadScreen/upload_screen.dart';
import 'Themes/themes.dart';

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
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/upload': (context) => UploadScreen(),
        },
        debugShowCheckedModeBanner: false);
  }
}
