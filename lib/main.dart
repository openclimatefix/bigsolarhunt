import 'package:flutter/material.dart';

import 'home_page.dart';
import 'Screens/UploadScreen/upload_screen.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/upload': (context) => UploadScreen(),
      },
      debugShowCheckedModeBanner: false));
}
