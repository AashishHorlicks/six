import 'dart:async';
import 'package:five_test_pointer/utils/app_constants.dart';
import 'package:five_test_pointer/utils/preference_manager.dart';
import 'package:flutter/material.dart';

import '../first_p.dart';
import '../home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      navigateFromSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }

  Future navigateFromSplash() {
    bool isLoggedIn = PreferenceManager.getBool(AppConstants.isLoggedIn);

    print("isLoggedIn   ----   $isLoggedIn ");
    if (isLoggedIn == null || !isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
