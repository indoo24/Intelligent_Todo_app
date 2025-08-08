import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static ThemeMode themeMode = ThemeMode.light;
  String language = 'en';
  SharedPreferences? prefs;

  bool get isDark => themeMode == ThemeMode.dark;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode =
        prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
    language = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> changeThemeMode(ThemeMode selectedThemeMode) async {
    themeMode = selectedThemeMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }

  Future<void> changeLanguage(String selectedLanguage) async {
    language = selectedLanguage;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
    notifyListeners();
  }
}
