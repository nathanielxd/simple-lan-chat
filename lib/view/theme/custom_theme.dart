import 'package:flutter/material.dart';

class CustomTheme {
  
  static ThemeData light = ThemeData(
    primaryColor: Color(0xfffafafa),
    accentColor: Color(0xff110036),
    backgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[200],
    canvasColor: Colors.white,
    fontFamily: 'OpenSans',
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xff0a0a0a)
      ),
      bodyText2: TextStyle(
        color: Colors.black
      )
    )
  );

  static ThemeData dark = ThemeData(
    primaryColor: Color(0xff1a1a1a),
    accentColor: Color(0xffe1e0ff),
    backgroundColor: Colors.black,
    canvasColor: Colors.black,
    fontFamily: 'OpenSans',
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xfff7f7f7)
      ),
      bodyText2: TextStyle(
        color: Colors.white
      )
    )
  );
}