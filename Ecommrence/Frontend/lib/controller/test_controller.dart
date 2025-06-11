// import 'package:ecommrence/core/class/statusrequest.dart';
// import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
// import 'package:ecommrence/data/datasource/remote/signup.dart';
// import 'package:get/get.dart';

// class TestController extends GetxController {
//   Signupdata testData = Signupdata(Get.find());

//   List data = [];

//   late StatusRequest statusRequest;

//   getData() async {
//     statusRequest = StatusRequest.loading;
//     var respone = await testData.getData();
//     print("=============================Controller $respone");

//     statusRequest = handlingData(respone);
//     if (StatusRequest.success == statusRequest) {
//       if (respone['status'] == "success") {
//         data.addAll(respone['data']);
//       } else {
//         statusRequest = StatusRequest.failure;
//       }
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     getData();
//     super.onInit();
//   }
// }
