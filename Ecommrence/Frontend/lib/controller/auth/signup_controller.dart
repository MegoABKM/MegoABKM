import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/data/datasource/remote/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SignupController extends GetxController {
  signup();
  goToLogin();
}

class SignupControllerImp extends SignupController {
  Signupdata signupdata = Signupdata(Get.find());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController username;
  late TextEditingController phone;
  StatusRequest? statusRequest;

  // List data = [];
  @override
  signup() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var respone = await signupdata.postData(
          username.text, password.text, email.text, phone.text);

      print("=============================Controller $respone");

      statusRequest = handlingData(respone);

      print("==============controller${statusRequest}");

      if (StatusRequest.success == statusRequest) {
        if (respone['status'] == "success") {
          // data.addAll(respone['data']);
          Get.offNamed(AppRoute.verifyCodeSignup,
              arguments: {"email": email.text});
        } else {
          Get.defaultDialog(
              title: "warning",
              middleText: "phone Number Or Email Already Exists");
          statusRequest = StatusRequest.failure;
        }
      }

      update();
    } else {}
  }

  @override
  goToLogin() {
    Get.toNamed(AppRoute.login);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    username = TextEditingController();
    phone = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    phone.dispose();
    super.dispose();
  }
}
