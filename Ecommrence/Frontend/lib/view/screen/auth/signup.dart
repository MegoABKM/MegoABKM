import 'package:ecommrence/controller/auth/signup_controller.dart';
import 'package:ecommrence/core/class/handlingdataauthview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/functions/alertexitapp.dart';
import 'package:ecommrence/core/functions/validinput.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtextformauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:ecommrence/view/widget/auth/textsignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignupControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "21".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: WillPopScope(
            onWillPop: () => alertExitApp(),
            child: GetBuilder<SignupControllerImp>(
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
                              const SizedBox(height: 20),
                              CustomTextTitleAuth(text: "22".tr),
                              const SizedBox(height: 10),
                              CustomTextBodyAuth(bodyText: "23".tr),
                              const SizedBox(height: 15),
                              Customtextformauth(
                                isNumber: false,
                                validator: (val) {
                                  return validInput(val!, 2, 30, 'username');
                                },
                                mycontroller: controller.username,
                                texthint: "24".tr,
                                label: "25".tr,
                                iconData: Icons.person,
                              ),
                              Customtextformauth(
                                isNumber: false,
                                validator: (val) {
                                  return validInput(val!, 5, 100, 'email');
                                },
                                mycontroller: controller.email,
                                texthint: "26".tr,
                                label: "27".tr,
                                iconData: Icons.email_outlined,
                              ),
                              Customtextformauth(
                                isNumber: true,
                                validator: (val) {
                                  return validInput(val!, 5, 40, 'phone');
                                },
                                mycontroller: controller.phone,
                                texthint: "28".tr,
                                label: "29".tr,
                                iconData: Icons.phone,
                              ),
                              Customtextformauth(
                                isNumber: false,
                                validator: (val) {
                                  return validInput(val!, 5, 30, 'password');
                                },
                                mycontroller: controller.password,
                                texthint: "30".tr,
                                label: "31".tr,
                                iconData: Icons.lock_outlined,
                              ),
                              CustomButtonAuth(
                                textbutton: "32".tr,
                                onPressed: () {
                                  controller.signup();
                                },
                              ),
                              const SizedBox(height: 30),
                              CustomTextSignupOrSignin(
                                text: "33".tr,
                                textbutton: "34".tr,
                                onTap: () {
                                  controller.goToLogin();
                                },
                              )
                            ],
                          ),
                        ))),
              ),
            )));
  }
}
