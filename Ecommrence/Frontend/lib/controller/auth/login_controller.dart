import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/auth/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
  login();
  goToSignup();
  goToForgetPassword();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  LoginData loginData = LoginData(Get.find());
  late TextEditingController email;
  late TextEditingController password;
  bool valuebool = true;

  MyServices myServices = Get.find();
  StatusRequest? statusRequest;

  @override
  login() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var respone = await loginData.postData(
        email.text,
        password.text,
      );

      statusRequest = handlingData(respone);

      print("==============controller${statusRequest}");

      if (StatusRequest.success == statusRequest) {
        if (respone['status'] == "success") {
          // data.addAll(respone['data']);
          if (respone['data']['users_approve'] == 1) {
            myServices.sharedPreferences
                .setString("id", respone['data']["users_id"].toString());
            String userid = myServices.sharedPreferences.getString("id")!;
            myServices.sharedPreferences
                .setString("username", respone['data']["users_name"]);
            myServices.sharedPreferences
                .setString("email", respone['data']["users_email"]);
            myServices.sharedPreferences
                .setString("phone", respone['data']["users_phone"]);
            myServices.sharedPreferences.setString("step", "2");
            FirebaseMessaging.instance.subscribeToTopic("users");
            FirebaseMessaging.instance.subscribeToTopic("users${userid}");
            Get.offAllNamed(AppRoute.home);
          } else {
            print("${respone}");
            Get.toNamed(AppRoute.verifyCodeSignup,
                arguments: {"email": email.text});
          }
        } else {
          Get.defaultDialog(
              title: "warning", middleText: "Email Or Password Wrong");
          statusRequest = StatusRequest.failure;
        }
      }

      update();
    } else {}
  }

  changeObsecure() {
    valuebool = valuebool == true ? false : true;
    update();
    print("Changed=================");
  }

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signUp);
  }

  @override
  goToForgetPassword() {
    Get.toNamed(AppRoute.forgetPassword);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
