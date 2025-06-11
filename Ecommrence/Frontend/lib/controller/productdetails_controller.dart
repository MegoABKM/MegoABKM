import 'package:ecommrence/controller/cart_controller.dart';
import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/cart_data.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ProductdetailsController extends GetxController {}

class ProductdetailsControllerImp extends ProductdetailsController {
  late ItemsModel itemsModel;

  StatusRequest? statusRequest;

  CartData cartData = CartData(Get.find());
  MyServices myServices = Get.find();

  // CartController cartController = Get.put(CartController());
  int countitems = 0;

  addCartItem(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();
    var respone = await cartData.addCartItem(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        Get.rawSnackbar(messageText: const Text("Added To Cart"));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }

    update();
  }

  removeCartItem(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();
    var respone = await cartData.removeCartItem(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        Get.rawSnackbar(
          messageText: const Text("Removed From Cart"),
        );
      } else {
        statusRequest = StatusRequest.failure;
      }
    }

    update();
  }

  getCountItem(String itemsid) async {
    statusRequest = StatusRequest.loading;

    var respone = await cartData.getcount(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        int countItems = 0;
        countItems = respone['data'];
        print("==========================$countItems");
        return countItems;
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
  }

  initialData() async {
    statusRequest = StatusRequest.loading;
    update();
    itemsModel = Get.arguments['itemsmodel'];
    countitems = await getCountItem(itemsModel.itemsId.toString());
    statusRequest = StatusRequest.success;
    update();
  }

  add() {
    addCartItem(itemsModel.itemsId.toString());
    countitems++;
    update();
  }

  remove() {
    if (countitems > 0) {
      removeCartItem(itemsModel.itemsId.toString());

      countitems--;
      update();
    }
  }

  goToCart() {
    Get.toNamed(AppRoute.cart);
  }

  List subItems = [
    {"name": "red", "id": 1, "active": 0},
    {"name": "yellow", "id": 2, "active": 0},
    {"name": "black", "id": 3, "active": 1}
  ];

  @override
  void onInit() {
    initialData();
    super.onInit();
  }
}
