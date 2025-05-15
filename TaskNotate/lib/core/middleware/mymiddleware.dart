import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final myServices = Get.find<StorageService>();
    final isEnabled =
        myServices.sharedPreferences.getBool('app_is_enabled') ?? true;
    if (!isEnabled) {
      return const RouteSettings(name: AppRoute.disabled);
    }

    final String? step = myServices.sharedPreferences.getString("step");
    if (step == "1") {
      return const RouteSettings(name: AppRoute.splashScreen);
    }

    return null;
  }
}
