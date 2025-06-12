import 'package:flutter/material.dart';
import 'package:schoolmanagement/core/constant/color.dart';

ThemeData themeEnglish = ThemeData(
  fontFamily: "NotoKufiArabic",
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
    bodyLarge: TextStyle(
        height: 2,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodyMedium: TextStyle(
        height: 2,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14),
    bodySmall: TextStyle(height: 2, color: Colors.white, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);

ThemeData themeArabic = ThemeData(
  fontFamily: "NotoKufiArabic",
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.black),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.black),
    bodyLarge: TextStyle(
        height: 2,
        color: AppColor.black,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodyMedium: TextStyle(
        height: 2,
        color: AppColor.black,
        fontWeight: FontWeight.bold,
        fontSize: 14),
    bodySmall: TextStyle(height: 2, color: AppColor.black, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);
