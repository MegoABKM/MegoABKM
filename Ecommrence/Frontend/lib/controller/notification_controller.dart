import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/notification_data.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  List notificaitonlist = [];

  MyServices myServices = Get.find();
  NotificationData notificationData = NotificationData(Get.find());

  StatusRequest? statusRequest;

  getData() async {
    notificaitonlist.clear();
    statusRequest = StatusRequest.loading;
    update();
    var respone = await notificationData
        .getData(myServices.sharedPreferences.getString("id")!);
    // ignore: avoid_print
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        notificaitonlist.addAll(respone['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
