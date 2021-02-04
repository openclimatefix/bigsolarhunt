import 'package:flutter/material.dart';

import 'OnboardingScreenWidgets/onboarding_page.dart';
import 'OnboardingScreenWidgets/indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController;
  double currentIndex = 0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  closeFunction() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page;
      });
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(controller: _pageController, children: onboardingPages),
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: Indicator(
              numPages: onboardingPages.length,
              currentIndex: currentIndex,
              onNextPage: nextFunction,
              onClosePage: closeFunction,
            ),
          )
        ],
      ),
    );
  }
}

List<OnboardingPage> onboardingPages = [
  OnboardingPage(
      title: "Discover",
      description: "Explore your area to find rooftop panels",
      widget: Image.asset('assets/onboarding-discover.png')),
  OnboardingPage(
      title: "Capture",
      description:
          "Take a photo of your discovered panel (make sure you have permission!)",
      widget: Image.asset('assets/onboarding-capture.png')),
  OnboardingPage(
      title: "Contribute",
      description: "Upload your photo to the OCF project",
      widget: Image.asset('assets/onboarding-contribute.png'))
];
