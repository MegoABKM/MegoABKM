import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/data/datasource/remote/orderdetail_data.dart';
import 'package:ecommrence/data/model/cartmodel.dart';
import 'package:ecommrence/data/model/ordersmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class OrdersDetailsController extends GetxController {
  OrderdetailData orderdetail = OrderdetailData(Get.find());

  StatusRequest? statusRequest;
  List<CartModel> orderdetailslist = [];

  OrdersModel? ordersModel;
  final MapController mapController = MapController();
  LatLng? markerPosition;
  String? streetName;
  String? cityName;
  String? lat;
  String? long;
  late TextEditingController nameLocation;

  getorderdetails() async {
    statusRequest = StatusRequest.loading;
    var respone = await orderdetail.getData(ordersModel!.ordersId.toString());
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        List newdata = respone["data"];
        orderdetailslist.addAll(newdata.map((e) => CartModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();

    ordersModel = Get.arguments?["ordermodel"];
    if (ordersModel != null && ordersModel!.addressLat != null) {
      markerPosition =
          LatLng(ordersModel!.addressLat!, ordersModel!.addressLong!);
    }
    getorderdetails();
  }
}
