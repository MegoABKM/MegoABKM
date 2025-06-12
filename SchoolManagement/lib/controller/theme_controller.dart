import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart' as AppThemes;

class ThemeController extends GetxController {
  late SharedPreferences _prefs;
  ThemeData currentTheme = AppThemes.lightTheme;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void _loadThemeFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String theme = _prefs.getString('theme') ?? 'light';

    if (theme == 'dark') {
      currentTheme = AppThemes.darkTheme;
    } else {
      currentTheme = AppThemes.lightTheme;
    }
    update();
  }

  void changeTheme(String theme) async {
    if (theme == 'dark') {
      currentTheme = AppThemes.darkTheme;
    } else {
      currentTheme = AppThemes.lightTheme;
    }

    await _prefs.setString('theme', theme);
    update(); 
  }
}
