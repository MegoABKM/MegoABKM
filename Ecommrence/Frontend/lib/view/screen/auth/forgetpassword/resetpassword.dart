import 'package:ecommrence/controller/auth/resetpassword_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/functions/validinput.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:ecommrence/view/widget/auth/customtextbodyauth.dart';
import 'package:ecommrence/view/widget/auth/customtextformauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetControllerImp());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0.0,
          title: Text(
            "44".tr,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColor.grey,
                ),
          ),
        ),
        body: GetBuilder<ResetControllerImp>(
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
                            CustomTextBodyAuth(bodyText: "45".tr),
                            const SizedBox(height: 25),
                            Customtextformauth(
                              isNumber: false,
                              validator: (val) {
                                return validInput(val!, 5, 30, 'password');
                              },
                              mycontroller: controller.password,
                              texthint: "46".tr,
                              label: "47".tr,
                              iconData: Icons.lock_outline,
                            ),
                            Customtextformauth(
                              isNumber: false,
                              validator: (val) {
                                return validInput(val!, 5, 30, 'password');
                              },
                              mycontroller: controller.repassword,
                              texthint: "48".tr,
                              label: "49".tr,
                              iconData: Icons.lock_outline,
                            ),
                            CustomButtonAuth(
                              textbutton: "50".tr,
                              onPressed: () {
                                controller.resetpassword();
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      )))),
        ));
  }
}
