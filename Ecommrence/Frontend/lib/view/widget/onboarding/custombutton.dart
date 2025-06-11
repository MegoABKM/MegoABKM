import 'package:ecommrence/controller/onboarding_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustombuttonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustombuttonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      height: 40,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
        textColor: Colors.white,
        onPressed: () {
          controller.next();
        },
        color: AppColor.primarycolor,
        child: Text(
          "continue".tr,
        ),
      ),
    );
  }
}
