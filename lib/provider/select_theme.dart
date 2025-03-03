import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectTheme extends ChangeNotifier {
  ThemeMode appTheme = ThemeMode.light;

  ThemeMode get themeState => appTheme;

  SelectTheme() {
    _loadTheme();
  }

  void selectTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (appTheme == ThemeMode.light) {
      appTheme = ThemeMode.dark;
      prefs.setBool('isDark', true);
    } else {
      appTheme = ThemeMode.light;
      prefs.setBool('isDark', false);
    }
    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDark') ?? false;
    appTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
