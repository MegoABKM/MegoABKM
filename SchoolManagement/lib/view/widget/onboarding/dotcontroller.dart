import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/onboarding_controller.dart';
import 'package:schoolmanagement/core/constant/color.dart';
import 'package:schoolmanagement/data/datasource/static/static.dart';

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
                            ? Theme.of(context).colorScheme.tertiary
                            : AppColor.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ));
  }
}
