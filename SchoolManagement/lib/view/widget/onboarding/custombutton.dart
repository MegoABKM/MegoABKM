import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/onboarding_controller.dart';

class CustomButtonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomButtonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20), // إضافة هامش علوي وسفلي
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(
            horizontal: 100), // زيادة التباعد العمودي
        onPressed: () {
          controller.next();
        },
        color: Theme.of(context).colorScheme.tertiary, // لون الخلفية البرتقالي
        // textColor: Colors.black, // لون النص الأبيض
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // زوايا مستديرة
        ),
        child: const Text(
          "التالي",
          style: TextStyle(
            fontSize: 18, // زيادة حجم الخط
            fontWeight: FontWeight.bold, // جعل النص عريضًا
          ),
        ),
      ),
    );
  }
}
