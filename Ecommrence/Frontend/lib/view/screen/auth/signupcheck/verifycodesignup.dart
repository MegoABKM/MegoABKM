import 'package:ecommrence/controller/auth/verifysignup_controller.dart';
import 'package:ecommrence/core/class/handlingdataauthview.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class VerifyCodeSignup extends StatelessWidget {
  const VerifyCodeSignup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifySignupControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "55".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: GetBuilder<VerifySignupControllerImp>(
            builder: (controller) => HandlingDataAuthview(
                  statusRequest: controller.statusRequest,
                  widget: Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 40),
                          child: Handlingdataview(
                              statusRequest: controller.statusRequest,
                              widget: ListView(
                                children: [
                                  const SizedBox(height: 20),
                                  CustomTextTitleAuth(text: "56".tr),
                                  const SizedBox(height: 10),
                                  CustomTextBodyAuth(bodyText: "57".tr),
                                  const SizedBox(height: 5),
                                  CustomTextBodyAuth(
                                      bodyText: controller.email!),
                                  const SizedBox(height: 5),
                                  OtpTextField(
                                    showCursor: true,
                                    borderRadius: BorderRadius.circular(20),
                                    borderWidth: 5,
                                    fieldWidth: 50,
                                    numberOfFields: 5,
                                    borderColor: const Color(0xFF512DA8),
                                    showFieldAsBox: true,
                                    onCodeChanged: (String code) {},
                                    onSubmit: (String verificationCode) {
                                      controller.verifycode = verificationCode;
                                      print(
                                          " controller verifycode is ==${controller.verifycode}");
                                      controller.checkemail();
                                    },
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 40,
                                  ),
                                  const CustomTextBodyAuth(
                                      bodyText: "Didn't Receive Code?"),
                                  Center(
                                    child: InkWell(
                                        onTap: () {
                                          controller.resend();
                                        },
                                        child: const Text("Resend code",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ))),
                                  ),
                                ],
                              )))),
                )));
  }
}
