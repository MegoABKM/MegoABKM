import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    MyServices myServices = Get.find();

    if (myServices.sharedPreferences.getString("step") == "2") {
      return const RouteSettings(name: AppRoute.home);
    }
    if (myServices.sharedPreferences.getString("step") == "1") {
      return const RouteSettings(name: AppRoute.login);
    }
  }
}
