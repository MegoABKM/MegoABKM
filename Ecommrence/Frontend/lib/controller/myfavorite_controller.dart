import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/myfavorite_data.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/data/model/myfavoritemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFavoriteController extends GetxController {
  List<MyFavoriteModel> data = [];
  StatusRequest? statusRequest;
  MyfavoriteData myFavoriteData = MyfavoriteData(Get.find());
  MyServices myServices = Get.find();

  getData() async {
    data.clear();
    statusRequest = StatusRequest.loading;
    var respone = await myFavoriteData
        .getData(myServices.sharedPreferences.getString("id")!);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        List responsedata = respone["data"];
        data.addAll(responsedata.map((e) => MyFavoriteModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      update();
    }
  }

  removeData(String id) {
    // statusRequest = StatusRequest.loading;
    var respone = myFavoriteData.removedata(id);
    print("=============================Controller $respone");

    data.removeWhere((e) => e.favoriteId.toString() == id);
    Get.rawSnackbar(messageText: const Text("Deleted From Favorite"));

    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
