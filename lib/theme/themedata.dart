import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
      backgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: HexColor("#00ca99")),
      popupMenuTheme: PopupMenuThemeData(color: Colors.white30),
      primaryTextTheme: TextTheme(
          button: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black)));
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Color.fromRGBO(0, 25, 25, 10),
    appBarTheme: AppBarTheme(backgroundColor: Color.fromRGBO(0, 65, 65, 10)),
    popupMenuTheme: PopupMenuThemeData(color: Color.fromRGBO(0, 25, 25, 10)),
    primaryTextTheme: TextTheme(
        button: TextStyle(color: Colors.white),
        bodyText1: TextStyle(color: Colors.white70)),
  );
}
