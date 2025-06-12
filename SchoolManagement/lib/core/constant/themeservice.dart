import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'themeMode';

  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }

  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'light'; // Default to light theme
  }
}
