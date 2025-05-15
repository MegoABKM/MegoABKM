import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/data/datasource/static/static.dart';

abstract class OnboardingController extends GetxController {
  next();
  onPageChanged(int index);
}

class OnBoardingControllerImp extends OnboardingController {
  late PageController pageController;
  int currentpage = 0;

  @override
  next() {
    print('next() called, currentpage: $currentpage');
    currentpage++;
    if (currentpage > onBoardingList.length - 1) {
      print('Completing onboarding, setting step to 1');
      Get.find<StorageService>().sharedPreferences.setString("step", "1");
      Get.offAllNamed(AppRoute.home);
    } else {
      print('Animating to page: $currentpage');
      pageController.animateToPage(
        currentpage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  onPageChanged(int index) {
    print('onPageChanged called, index: $index');
    currentpage = index;
    update();
  }

  @override
  void onInit() {
    print('OnBoardingControllerImp initialized');
    pageController = PageController();
    super.onInit();
  }
}
