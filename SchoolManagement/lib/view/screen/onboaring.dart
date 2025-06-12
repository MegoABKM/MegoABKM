import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/onboarding_controller.dart';
import 'package:schoolmanagement/core/constant/routes.dart';
import 'package:schoolmanagement/view/widget/onboarding/custombutton.dart';
import 'package:schoolmanagement/view/widget/onboarding/customslider.dart';
import 'package:schoolmanagement/view/widget/onboarding/dotcontroller.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp());

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Get.offNamed(AppRoute.login);
              },
              child: const Text(
                "تخطي",
                style: TextStyle(color: Colors.black87),
              ))
        ],
        centerTitle: true,
        title: const Text(
          "مرشد",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: CustomSliderOnBoarding(),
            ),
            CustomButtonOnBoarding(),
            SizedBox(height: 10),
            CustomDotControllerOnBoarding(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
