import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/archive_data.dart';
import 'package:ecommrence/data/model/ordersmodel.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController {
  StatusRequest? statusRequest;
  OrdersArchiveData ordersarchiveData = OrdersArchiveData(Get.find());
  MyServices myServices = Get.find();
  List<OrdersModel> orders = [];

  String printOrderType(String val) {
    if (val == "0") {
      return "Delivery";
    } else {
      return "Receive";
    }
  }

  printPaymentMethod(String val) {
    if (val == "0") {
      return "Cash On Delivery";
    } else {
      return "Payment Card";
    }
  }

  printOrderStatus(String val) {
    if (val == "0") {
      return "Pending Approval";
    } else if (val == "1") {
      return "Preparing Order";
    } else if (val == "2") {
      return "On The Way";
    } else {
      return "Archived";
    }
  }

  getOrders() async {
    orders.clear();
    statusRequest = StatusRequest.loading;
    update();
    var respone = await ordersarchiveData
        .getData(myServices.sharedPreferences.getString("id"));
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        List listData = respone['data'];

        orders.addAll(listData.map((e) => OrdersModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  refreshOrder() {
    getOrders();
  }

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }
}
