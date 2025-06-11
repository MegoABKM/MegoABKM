import 'package:ecommrence/core/constant/routes.dart';
import 'package:get/get.dart';

abstract class SuccessSignupController extends GetxController {
  goToLogin();
}

class SuccessSignupControllerImp extends SuccessSignupController {
  @override
  goToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
