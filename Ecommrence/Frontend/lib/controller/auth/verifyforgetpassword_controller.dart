import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/data/datasource/remote/auth/verifycodedata.dart';
import 'package:get/get.dart';

abstract class VerifyPasswordController extends GetxController {
  checkCode();
}

class VerifyPasswordControllerImp extends VerifyPasswordController {
  VerifyCodeResetData verifyCodeResetData = VerifyCodeResetData(Get.find());
  late String verifycode;

  String? email;

  StatusRequest? statusRequest;
  @override
  checkCode() async {
    statusRequest = StatusRequest.loading;
    update();
    print("=================verifycode is ${verifycode}");
    var respone = await verifyCodeResetData.postData(email!, verifycode);
    print("=============================Controller $respone");
    statusRequest = handlingData(respone);

    print("==============controller${statusRequest}");

    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        // data.addAll(respone['data']);
        Get.offNamed(AppRoute.resetPassword, arguments: {"email": email});
      } else {
        Get.defaultDialog(
            title: "warning", middleText: "verify code is not correct");
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    email = Get.arguments["email"];
    super.onInit();
  }
}
