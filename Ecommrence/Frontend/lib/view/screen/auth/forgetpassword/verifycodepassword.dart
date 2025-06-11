import 'package:ecommrence/controller/auth/verifyforgetpassword_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class VerifyCode extends StatelessWidget {
  const VerifyCode({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyPasswordControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "41".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: GetBuilder<VerifyPasswordControllerImp>(
          builder: (controller) => Handlingdataview(
              statusRequest: controller.statusRequest,
              widget: Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 40),
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          CustomTextTitleAuth(text: "42".tr),
                          const SizedBox(height: 10),
                          CustomTextBodyAuth(bodyText: "43".tr),
                          const SizedBox(height: 15),
                          OtpTextField(
                            borderRadius: BorderRadius.circular(20),
                            borderWidth: 5,
                            fieldWidth: 50,
                            numberOfFields: 5,
                            borderColor: const Color(0xFF512DA8),
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {},
                            onSubmit: (String verificationCode) {
                              controller.verifycode = verificationCode;
                              controller.checkCode();
                            },
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 40,
                          ),
                        ],
                      )))),
        ));
  }
}
