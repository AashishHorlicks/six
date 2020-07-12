import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


import './service/auth.dart';
import 'home.dart';




class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/point.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: FadeAnimatedTextKit(
                  duration: Duration(milliseconds: 10000),
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                  text: ["JOURNEY BEGINS"],
                  alignment: AlignmentDirectional.centerStart,
                  textAlign: TextAlign.center,
                  textStyle: GoogleFonts.courgette(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height:10),
              RaisedButton(
                onPressed: (){
                  FirebaseAuth.instance
                  .signInAnonymously()
                  .then((FirebaseUser){
                     Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
                  }).catchError((e){
                    print(e);
                  });
                },
                ),
              RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
          builder: (context) => StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged, builder: (ctx, userSnapshot) {
        if (userSnapshot.hasData) {
          return HomePage();
        }else {
          return AuthScreen();
          }
        
      }),
          ));
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}