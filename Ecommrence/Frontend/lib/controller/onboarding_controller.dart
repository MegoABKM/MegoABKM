import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OnboardingController extends GetxController {
  next();

  onPageChanged(int index);
}

class OnBoardingControllerImp extends OnboardingController {
  late PageController pageController;
  int currentpage = 0;
  MyServices myServices = Get.find();

  @override
  next() {
    currentpage++;

    if (currentpage > onBoardingList.length - 1) {
      myServices.sharedPreferences.setString("step", "1");
      Get.offAllNamed(AppRoute.login);
    } else {
      pageController.animateToPage(currentpage,
          duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    }
  }

  @override
  onPageChanged(int index) {
    currentpage = index;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
