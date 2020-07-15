import 'package:five_test_pointer/pages/page_splash.dart';
import 'package:flutter/material.dart';

import './first_p.dart';
import 'utils/preference_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPreference();
  }

  initSharedPreference() async {
    await PreferenceManager.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
