import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/data/datasource/remote/auth/verifycode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class VerifySignupController extends GetxController {
  checkemail();
}

class VerifySignupControllerImp extends VerifySignupController {
  VerifyCodeSignupData verifycodedata = VerifyCodeSignupData(Get.find());
  String? email;
  late String verifycode;
  StatusRequest? statusRequest;
  @override
  checkemail() async {
    statusRequest = StatusRequest.loading;
    update();
    print("=================verifycode is ${verifycode}");
    var respone = await verifycodedata.postData(email!, verifycode);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);

    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        // data.addAll(respone['data']);
        Get.offNamed(AppRoute.successSignup);
      } else {
        Get.defaultDialog(
            title: "warning", middleText: "verify code is not correct");
      }
    }
    update();
  }

  resend() async {
    verifycodedata.resend(email!);
    Get.rawSnackbar(
      messageText: Text("verify code has been sent"),
      backgroundColor: AppColor.primarycolor,
    );
  }

  @override
  void onInit() {
    email = Get.arguments["email"];
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
