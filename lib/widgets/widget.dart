import 'package:flutter/material.dart';


Widget customcard(String langname, String tx) {
    return Padding(
      padding: EdgeInsets.all(
        30,
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 20.0,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
              ),
              Center(
                child: Text(
                  langname,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.redAccent,
                    //fontFamily:
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  tx,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 6,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
