import 'package:flutter/material.dart';

class ChatThemes {

  static ThemeData light = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.grey[200],
    fontFamily: 'Manrope',
    textTheme: TextTheme(
      headline3: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w700
      )
    )
  );
}