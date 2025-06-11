import 'package:ecommrence/controller/auth/successsignup_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessSignup extends StatelessWidget {
  const SuccessSignup({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessSignupControllerImp controller =
        Get.put(SuccessSignupControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "58".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: Center(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 200,
                    ),
                    const SizedBox(height: 20),
                    CustomTextTitleAuth(text: "59".tr),
                    const SizedBox(height: 10),
                    CustomTextBodyAuth(bodyText: "60".tr),
                    const SizedBox(height: 15),
                    CustomButtonAuth(
                      textbutton: "61".tr,
                      onPressed: () {
                        controller.goToLogin();
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ))));
  }
}
