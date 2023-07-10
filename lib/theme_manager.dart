import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  ThemeManager(this._themeData);
  Future<void> saveThemeMode(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeName);
  }

  Future<String> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'light';  // domyślny motyw
  }
  getTheme() => _themeData;

  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
