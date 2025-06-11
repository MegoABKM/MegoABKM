import 'package:ecommrence/controller/auth/successpassword_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessPasswordControllerImp controller =
        Get.put(SuccessPasswordControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "51".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: Center(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                    CustomTextTitleAuth(text: "52".tr),
                    const SizedBox(height: 10),
                    CustomTextBodyAuth(bodyText: "53".tr),
                    const SizedBox(height: 15),
                    CustomButtonAuth(
                      textbutton: "54".tr,
                      onPressed: () {
                        controller.goToLogin();
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ))));
  }
}
