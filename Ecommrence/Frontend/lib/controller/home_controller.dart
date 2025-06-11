import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/home_data.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends MixSearchController {
  initialData();
  getData();
  goToItems(List categories, int selectedCat, String categoryid);
}

class HomeControllerImp extends HomeController {
  MyServices myServices = Get.find();

  String? username;
  String? id;
  String? lang;

  List categories = [];
  List items = [];

  @override
  initialData() {
    lang = myServices.sharedPreferences.getString("lang");
    username = myServices.sharedPreferences.getString("username");
    id = myServices.sharedPreferences.getString("id");
  }

  @override
  getData() async {
    statusRequest = StatusRequest.loading;
    var respone = await homeData.getData();
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        categories.addAll(respone['categories']['data']);
        items.addAll(respone['items']['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    return token;
  }

  @override
  void onInit() {
    search = TextEditingController();
    initialData();
    getData();
    getDeviceToken();
    super.onInit();
  }

  @override
  goToItems(List categories, int selectedCat, String categoryid) {
    Get.toNamed(AppRoute.items, arguments: {
      "categories": categories,
      "selectedcat": selectedCat,
      "categoryid": categoryid
    });
  }

  goToPageProductDetails(itemsmodel) {
    Get.toNamed(AppRoute.productpage, arguments: {"itemsmodel": itemsmodel});
  }
}

class MixSearchController extends GetxController {
  HomeData homeData = HomeData(Get.find());

  StatusRequest? statusRequest;
  late ItemsModel searchedconverted;
  TextEditingController? search;
  List<ItemsModel> searchResult = [];
  bool isSearch = false;

  searchData(String search) async {
    statusRequest = StatusRequest.loading;
    var respone = await homeData.searchData(search);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        List searchedRespone = respone['data'];

        searchResult.clear();
        searchResult.addAll(searchedRespone.map((e) => ItemsModel.fromJson(e)));
        if (searchResult.isNotEmpty) {
          searchedconverted = searchResult.first;
        }

        print("=====$searchedconverted");

        print("==================$searchResult");
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  checkSearch(val) {
    if (val == "") {
      statusRequest = StatusRequest.none;
      isSearch = false;
    }
    update();
  }

  onSearchItems() {
    isSearch = true;
    update();
  }
}
