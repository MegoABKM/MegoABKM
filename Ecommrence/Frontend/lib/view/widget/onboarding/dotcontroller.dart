import 'package:ecommrence/controller/onboarding_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDotControllerOnBoarding extends StatelessWidget {
  const CustomDotControllerOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImp>(
        builder: (controller) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  onBoardingList.length,
                  (index) => AnimatedContainer(
                    margin: const EdgeInsets.only(right: 5),
                    duration: const Duration(milliseconds: 100),
                    width: controller.currentpage == index ? 15 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: controller.currentpage == index
                            ? AppColor.primarycolor
                            : AppColor.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ));
  }
}
