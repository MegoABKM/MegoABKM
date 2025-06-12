import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/core/constant/routes.dart';
import 'package:schoolmanagement/core/services/services.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    print('Middleware triggered for route: $route');
    print(
        'stepschool: ${myServices.sharedPreferences.getString("stepschool")}');
    print(
        'stepstudent: ${myServices.sharedPreferences.getString("stepstudent")}');
    print('step: ${myServices.sharedPreferences.getString("step")}');

    // School login check
    if (myServices.sharedPreferences.getString("stepschool") == "2" &&
        myServices.sharedPreferences.getString("step") == "1") {
      print('Redirecting to schoolhome');
      return const RouteSettings(name: AppRoute.schoolhome);
    }
    // Student login check
    else if (myServices.sharedPreferences.getString("stepstudent") == "2" &&
        myServices.sharedPreferences.getString("step") == "1") {
      print('Redirecting to studentdashboard');
      return const RouteSettings(name: AppRoute.studentdashboard);
    }
    // Default login check
    else if (myServices.sharedPreferences.getString("step") == "1") {
      print('Redirecting to login');
      return const RouteSettings(name: AppRoute.login);
    }

    print('No redirect applied');
    return null; // Proceed to the requested route if no conditions match
  }
}
