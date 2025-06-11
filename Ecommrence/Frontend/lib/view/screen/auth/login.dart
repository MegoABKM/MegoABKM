import 'package:ecommrence/controller/auth/login_controller.dart';
import 'package:ecommrence/core/class/handlingdataauthview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/functions/alertexitapp.dart';
import 'package:ecommrence/core/functions/validinput.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtextformauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:ecommrence/view/widget/auth/logoauth.dart';
import 'package:ecommrence/view/widget/auth/textsignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "10".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: WillPopScope(
            onWillPop: () {
              return alertExitApp();
            },
            child: GetBuilder<LoginControllerImp>(
                builder: (controller) => HandlingDataAuthview(
                      statusRequest: controller.statusRequest,
                      widget: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              child: Form(
                                key: controller.formstate,
                                child: ListView(
                                  children: [
                                    const Logouth(),
                                    const SizedBox(height: 20),
                                    CustomTextTitleAuth(text: "11".tr),
                                    const SizedBox(height: 10),
                                    CustomTextBodyAuth(bodyText: "12".tr),
                                    const SizedBox(height: 15),
                                    Customtextformauth(
                                      isNumber: false,
                                      validator: (val) {
                                        return validInput(
                                            val!, 5, 100, 'email');
                                      },
                                      mycontroller: controller.email,
                                      texthint: "13".tr,
                                      label: "14".tr,
                                      iconData: Icons.email_outlined,
                                    ),
                                    GetBuilder<LoginControllerImp>(
                                      builder: (controller) =>
                                          Customtextformauth(
                                        onTapIcon: () =>
                                            controller.changeObsecure(),
                                        obscureText: controller.valuebool,
                                        isNumber: false,
                                        validator: (val) {
                                          return validInput(
                                              val!, 5, 30, "password");
                                        },
                                        mycontroller: controller.password,
                                        texthint: "15".tr,
                                        label: "16".tr,
                                        iconData: Icons.lock_outlined,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.goToForgetPassword();
                                      },
                                      child: Text(
                                        "17".tr,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    CustomButtonAuth(
                                      textbutton: "18".tr,
                                      onPressed: () {
                                        controller.login();
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    CustomTextSignupOrSignin(
                                      text: "19".tr,
                                      textbutton: "20".tr,
                                      onTap: () {
                                        controller.goToSignup();
                                      },
                                    )
                                  ],
                                ),
                              ))),
                    ))));
  }
}
