import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends ChangeNotifier {
  String appLanguage = 'en';

  SelectLanguage() {
    loadLanguage();
  }

  Future<void> changeLanguage(String newLang) async {
    if (appLanguage != newLang) {
      appLanguage = newLang;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("code", appLanguage);
      notifyListeners();
    }
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString("code") ?? 'en';
    if (appLanguage != code) {
      appLanguage = code;
      notifyListeners();
    }
  }
}
