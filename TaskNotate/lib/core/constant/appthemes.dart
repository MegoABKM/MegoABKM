import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class AppThemes {
  static final StorageService myServices = Get.find<StorageService>();

  static TextTheme getCommonTextTheme() => TextTheme(
        displayLarge: TextStyle(
          fontSize: 96,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );

  static const double appBarElevation = 4.0;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  static const TextStyle dropdownTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle emptyTaskTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const BoxShadow cardBoxShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static ButtonThemeData buttonTheme(ColorScheme colorScheme) {
    return ButtonThemeData(
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: colorScheme.secondary, width: 2),
      ),
      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
      labelStyle: TextStyle(color: colorScheme.primary),
    );
  }

  // Expanded color palette with darker variants for light theme
  static final Map<String, Color> availableColors = {
    // Original colors (slightly darkened)
    'vibrantBlue': Color(0xFF1976D2),
    'sunsetCoral': Color(0xFFE64A19),
    'emeraldGreen': Color(0xFF27AE60),
    'royalPurple': Color(0xFF7B1FA2),
    'goldenYellow': Color(0xFFFFA000),
    'deepTeal': Color(0xFF00695C),
    'rubyRed': Color(0xFFD81B60),
    'oceanCyan': Color(0xFF00838F),
    'limeBurst': Color(0xFFAFB42B),
    'twilightIndigo': Color(0xFF303F9F),
    // Dark variants for original colors
    'darkVibrantBlue': Color(0xFF0D47A1),
    'darkSunsetCoral': Color(0xFFBF360C),
    'darkEmeraldGreen': Color(0xFF1B5E20),
    'darkRoyalPurple': Color(0xFF4A148C),
    'darkGoldenYellow': Color(0xFFF57F17),
    'darkDeepTeal': Color(0xFF004D40),
    'darkRubyRed': Color(0xFFB71C1C),
    'darkOceanCyan': Color(0xFF006064),
    'darkLimeBurst': Color(0xFF827717),
    'darkTwilightIndigo': Color(0xFF1A237E),
    // New colors
    'forestGreen': Color(0xFF2E7D32),
    'burntOrange': Color(0xFFEF6C00),
    'amethystPurple': Color(0xFFAB47BC),
    'sapphireBlue': Color(0xFF0D47A1),
    'crimsonRed': Color(0xFFB71C1C),
    'aquaMarine': Color(0xFF26A69A),
    'sunflowerYellow': Color(0xFFFFD600),
    'midnightBlue': Color(0xFF1A237E),
    'coralPink': Color(0xFFF06292),
    'oliveGreen': Color(0xFF4CAF50),
    // Dark variants for new colors
    'darkForestGreen': Color(0xFF1B5E20),
    'darkBurntOrange': Color(0xFFBF360C),
    'darkAmethystPurple': Color(0xFF6A1B9A),
    'darkSapphireBlue': Color(0xFF002171),
    'darkCrimsonRed': Color(0xFF7F0000),
    'darkAquaMarine': Color(0xFF00695C),
    'darkSunflowerYellow': Color(0xFFC6A700),
    'darkMidnightBlue': Color(0xFF0D1428),
    'darkCoralPink': Color(0xFFC2185B),
    'darkOliveGreen': Color(0xFF2E7D32),
  };

  static Color getPrimaryColor() {
    String? colorKey = myServices.sharedPreferences.getString('PrimaryColor');
    return availableColors[colorKey] ?? availableColors['vibrantBlue']!;
  }

  static Color getSecondaryColor() {
    String? colorKey = myServices.sharedPreferences.getString('SecondColor');
    return availableColors[colorKey] ?? availableColors['sunsetCoral']!;
  }

  static ThemeData lightTheme(String languageCode) {
    final primaryColor = getPrimaryColor();
    final secondaryColor = getSecondaryColor();

    return ThemeData(
      fontFamily: languageCode == "ar" ? "Cairo" : "OpenSans",
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.grey[200],
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      textTheme: getCommonTextTheme().apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      iconTheme: IconThemeData(color: primaryColor, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: appBarElevation,
        shadowColor: Colors.black26,
      ),
      buttonTheme: buttonTheme(ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      inputDecorationTheme: inputDecorationTheme(ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      dividerColor: Colors.grey[400],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ThemeData darkTheme(String languageCode) {
    final primaryColor = getPrimaryColor();
    final secondaryColor = getSecondaryColor();

    return ThemeData(
      fontFamily: languageCode == "ar" ? "Cairo" : "OpenSans",
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xFF1A1A1A),
      cardColor: Color(0xFF2C2C2C),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        surface: Color(0xFF2C2C2C),
        onSurface: Colors.white70,
      ),
      textTheme: getCommonTextTheme().apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white70,
      ),
      iconTheme: IconThemeData(color: secondaryColor, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: appBarElevation,
        shadowColor: Colors.black45,
      ),
      buttonTheme: buttonTheme(ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      inputDecorationTheme: inputDecorationTheme(ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      dividerColor: Colors.grey[800],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
