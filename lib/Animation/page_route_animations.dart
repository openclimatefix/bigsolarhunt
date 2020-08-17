import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class FadeThroughPageRoute extends PageRouteBuilder {
  FadeThroughPageRoute({Widget page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
            Widget child,
          ) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}
