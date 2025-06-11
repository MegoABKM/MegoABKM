import 'package:ecommrence/controller/onboarding_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.onPageChanged(value);
        },
        itemCount: onBoardingList.length,
        itemBuilder: (context, index) {
          return Column(children: [
            Text(
              onBoardingList[index].title!.tr,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColor.black),
            ),
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              onBoardingList[index].image!,
              // width: 200,
              // height: 230,
              height: Get.width / 1.6,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                onBoardingList[index].body!.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    height: 2,
                    color: AppColor.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ]);
        });
  }
}
