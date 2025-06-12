import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/onboarding_controller.dart';
import 'package:schoolmanagement/data/datasource/static/static.dart';

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50), 

      
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    onBoardingList[index].image!,
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              onBoardingList[index].title!.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26, 
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Body text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                onBoardingList[index].body!.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.8,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18, // Slightly larger font
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
