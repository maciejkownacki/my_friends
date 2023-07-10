import 'package:flutter/material.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
//  accentColor: Colors.blueAccent,
  // ... możesz dostosować inne atrybuty jak chcesz
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
//  accentColor: Colors.blueAccent,
  // ... możesz dostosować inne atrybuty jak chcesz
);

ThemeData oledTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
//  accentColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
  ),
  // ... dostosuj inne atrybuty jak chcesz
);

ThemeData matrixTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.green[800],
//  accentColor: Colors.greenAccent,
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.greenAccent),
    bodyText2: TextStyle(color: Colors.greenAccent),
  ),
  // ... dostosuj inne atrybuty jak chcesz
);