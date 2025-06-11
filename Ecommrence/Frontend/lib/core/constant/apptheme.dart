import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

ThemeData themeEnglish = ThemeData(
  fontFamily: "PlayfairDisplay",
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primarycolor),
  appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(
          fontFamily: "Cairo",
          color: AppColor.primarycolor,
          fontWeight: FontWeight.bold,
          fontSize: 25),
      backgroundColor: Colors.grey[50],
      centerTitle: true,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: AppColor.primarycolor)),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.black),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.black),
    bodyLarge: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodyMedium: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 14),
    bodySmall: TextStyle(height: 2, color: AppColor.grey, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);

ThemeData themeArabic = ThemeData(
  fontFamily: "Cairo",
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.black),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.black),
    bodyLarge: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodyMedium: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 14),
    bodySmall: TextStyle(height: 2, color: AppColor.grey, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);
