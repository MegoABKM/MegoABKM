import 'package:ecommrence/controller/auth/forget_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/functions/validinput.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtextformauth.dart';
import 'package:ecommrence/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "35".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: GetBuilder<ForgetControllerImp>(
            builder: (controller) => Handlingdataview(
                statusRequest: controller.statusRequest,
                widget: Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 40),
                        child: Form(
                          key: controller.formstate,
                          child: ListView(
                            children: [
                              const SizedBox(height: 20),
                              CustomTextTitleAuth(text: "36".tr),
                              const SizedBox(height: 10),
                              CustomTextBodyAuth(bodyText: "37".tr),
                              const SizedBox(height: 15),
                              Customtextformauth(
                                isNumber: false,
                                validator: (val) {
                                  return validInput(val!, 5, 100, 'email');
                                },
                                mycontroller: controller.email,
                                texthint: "38".tr,
                                label: "39".tr,
                                iconData: Icons.email_outlined,
                              ),
                              CustomButtonAuth(
                                textbutton: "40".tr,
                                onPressed: () {
                                  controller.checkemail();
                                },
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ))))));
  }
}
