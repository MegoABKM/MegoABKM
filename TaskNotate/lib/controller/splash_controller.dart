// lib/controller/splash_controller.dart
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxDouble opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Start fade-in animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isClosed) {
        // Check if the controller is still active
        opacity.value = 1.0;
      }
    });
  }

  // Optional: Reset opacity if the splash screen could be revisited
  // @override
  // void onClose() {
  //   opacity.value = 0.0;
  //   super.onClose();
  // }
}
