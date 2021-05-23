import 'package:flutter/material.dart';
import 'dart:io';

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}

class NotConnectedContainer extends StatelessWidget {
  const NotConnectedContainer({
    Key key,
    @required this.showtext,
  }) : super(key: key);

  final bool showtext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.portable_wifi_off_outlined, size: 40),
        showtext ? SizedBox(height: 12) : SizedBox(),
        showtext
            ? Text("No Connection",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold))
            : SizedBox(),
        showtext ? SizedBox(height: 12) : SizedBox(),
        showtext
            ? Text(
                "(Don't worry, you can still take pictures, and they'll be automatically uploaded alongside your next connected upload!)",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.onBackground))
            : SizedBox(),
      ],
    );
  }
}
