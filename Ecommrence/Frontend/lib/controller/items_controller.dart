import 'package:ecommrence/controller/home_controller.dart';
import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/items_data.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class ItemsController extends MixSearchController {
  initialData();
  changeCat(int val, String catVal);
  getItems(String categoryid);
  goToPageProductDetails(ItemsModel itemsmodel);
}

class ItemsControllerImp extends ItemsController {
  List items = [];
  List categories = [];
  int? selectedCat;
  late String catId;

  MyServices myServices = Get.find();
  ItemsData testData = ItemsData(Get.find());

  StatusRequest? statusRequest;

  @override
  getItems(categoryid) async {
    items.clear();
    statusRequest = StatusRequest.loading;
    var respone = await testData.getData(
        categoryid, myServices.sharedPreferences.getString("id")!);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        items.addAll(respone['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  goToPageProductDetails(itemsmodel) {
    Get.toNamed(AppRoute.productpage, arguments: {"itemsmodel": itemsmodel});
  }

  @override
  initialData() {
    categories = Get.arguments['categories'];
    selectedCat = Get.arguments['selectedcat'];
    catId = Get.arguments['categoryid'];
    search = TextEditingController();
    getItems(catId);
  }

  @override
  changeCat(val, catVal) {
    selectedCat = val;
    catId = catVal;
    getItems(catId);
    update();
  }

  @override
  void onInit() {
    initialData();
  }
}
