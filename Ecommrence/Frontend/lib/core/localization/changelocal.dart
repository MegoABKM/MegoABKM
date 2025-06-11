import 'package:ecommrence/core/constant/apptheme.dart';
import 'package:ecommrence/core/functions/fcm.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  ThemeData appTheme = themeEnglish;

  changeLang(String lang) {
    Locale locale = Locale(lang);

    myServices.sharedPreferences.setString("lang", lang);
    appTheme = lang == "ar" ? themeArabic : themeEnglish;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? sharedprefLang = myServices.sharedPreferences.getString("lang");

    if (sharedprefLang == "ar") {
      language = const Locale("ar");
      appTheme = themeArabic;
    } else if (sharedprefLang == "en") {
      language = const Locale("en");
      appTheme = themeEnglish;
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
      appTheme = themeEnglish;
    }

    fcmconfig();
    requestPermissionNotification();

    super.onInit();
  }
}
