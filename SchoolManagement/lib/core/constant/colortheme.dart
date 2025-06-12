// lib/core/constant/colortheme.dart
import 'package:flutter/material.dart';

class AppThemes {
  static TextTheme getCommonTextTheme() => const TextTheme(
        displayLarge: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        displayMedium: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        displaySmall: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        headlineMedium: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic'),
        bodyLarge: TextStyle(fontSize: 16, fontFamily: 'NotoKufiArabic'),
        bodyMedium: TextStyle(fontSize: 14, fontFamily: 'NotoKufiArabic'),
        bodySmall: TextStyle(fontSize: 12, fontFamily: 'NotoKufiArabic'),
      );

  static const double appBarElevation = 4.0;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  static const TextStyle dropdownTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle emptyTaskTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const BoxShadow cardBoxShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 5,
    offset: Offset(0, 3),
  );

  static ButtonThemeData buttonTheme(ColorScheme colorScheme) {
    return ButtonThemeData(
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.secondary),
      ),
      hintStyle: TextStyle(color: colorScheme.onBackground),
      labelStyle: TextStyle(color: colorScheme.primary),
    );
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF212121),
  scaffoldBackgroundColor: const Color(0xFF212121),
  cardColor: const Color(0xFF424242),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF212121),
    onPrimary: Colors.white,
    secondary: Color(0xFFFFD600),
    onSecondary: Colors.black,
    background: Color(0xFF212121),
    onBackground: Colors.white,
    surface: Color(0xFF424242),
    onSurface: Colors.white,
    tertiary: Color(0xFFFFAB00),
    onTertiary: Colors.black,
  ),
  textTheme: AppThemes.getCommonTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFFFD600),
    size: 24,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFD600),
    foregroundColor: Colors.black,
    elevation: 4,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD600),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFD600), width: 2),
    ),
    labelStyle: const TextStyle(
      color: Colors.white70,
      fontFamily: 'NotoKufiArabic',
    ),
    hintStyle: TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontFamily: 'NotoKufiArabic',
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFFFD600), // Set CircularProgressIndicator color globally
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF212121),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1F1F1F),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF212121),
    onPrimary: Colors.white,
    secondary: Color(0xFFFFD600),
    onSecondary: Colors.black,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF1F1F1F),
    onSurface: Colors.white,
  ),
  textTheme: AppThemes.getCommonTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFFFD600),
    size: 24,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFD600),
    foregroundColor: Colors.black,
    elevation: 4,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD600),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        fontFamily: 'NotoKufiArabic',
        fontSize: 16,
      ),
    ),
  ),
  inputDecorationTheme: AppThemes.inputDecorationTheme(const ColorScheme.dark(
    primary: Color(0xFF212121),
    secondary: Color(0xFFFFD600),
  )),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFFFD600), // Set CircularProgressIndicator color globally
  ),
);
