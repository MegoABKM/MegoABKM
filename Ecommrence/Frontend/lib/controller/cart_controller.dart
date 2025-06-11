import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/cart_data.dart';
import 'package:ecommrence/data/model/cartmodel.dart';
import 'package:ecommrence/data/model/couponmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  List<CartModel> data = [];
  CouponModel? couponModel;
  String priceorders = "";
  String totalcountitems = "";
  int discountcoupon = 0;
  String? couponname;
  String? couponid;
  TextEditingController? controllercoupon;
  StatusRequest? statusRequest;
  CartData cartData = CartData(Get.find());
  MyServices myServices = Get.find();

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

  resetVarCart() {
    totalcountitems = "";
    priceorders = "";
    data.clear();
  }

  refreshPage() {
    resetVarCart();
    viewcart();
  }

  viewcart() async {
    statusRequest = StatusRequest.loading;
    update();

    var respone = await cartData
        .viewusercart(myServices.sharedPreferences.getString("id")!);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        if (respone['datacart']['status'] == 'success') {
          List datarepsone = respone['datacart']['data'];
          Map datatotalcountitems = respone['countprice'];
          data.clear();
          data.addAll(datarepsone.map((e) => CartModel.fromJson(e)));
          totalcountitems =
              datatotalcountitems['totalcount']?.toString() ?? "0";
          priceorders = datatotalcountitems['totalprice']?.toString() ?? "0";
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  checkCoupon() async {
    statusRequest = StatusRequest.loading;
    update();
    var respone = await cartData.checkCoupon(controllercoupon!.text);
    print("=============================Controller $respone");

    statusRequest = handlingData(respone);
    if (StatusRequest.success == statusRequest) {
      if (respone['status'] == "success") {
        Map<String, dynamic> couponInfo = respone['data'];
        couponModel = CouponModel.fromJson(couponInfo);
        discountcoupon = int.parse(couponModel!.couponDiscount!);
        couponname = couponModel!.couponName;
        couponid = couponModel!.couponId;
      } else {
        discountcoupon = 0;
        couponname = null;
        Get.rawSnackbar(
            messageText: const Text("No Vaild Coupon"),
            snackPosition: SnackPosition.TOP);
      }
    }
    update();
  }

  double convertedpriceorder() {
    try {
      double doubledpriceorder = double.parse(priceorders);
      return doubledpriceorder;
    } catch (e) {
      return 0.0;
    }
  }

  double getTotalPrice() {
    // Try to parse the priceorders string to a double
    try {
      double doubledpriceorder = double.parse(priceorders);
      return doubledpriceorder - doubledpriceorder * discountcoupon / 100;
    } catch (e) {
      // In case of an error, log it and return 0.0
      print("Error parsing priceorders: $e");
      return 0.0; // Default value in case of error
    }
  }

  goToCheckout() {
    if (data.isEmpty)
      return Get.snackbar(
        "ALert",
        "No Items",
      );
    Get.toNamed(AppRoute.checkOut, arguments: {
      "couponid": couponid ?? "0",
      "totalprice": priceorders,
      "coupondiscount": discountcoupon.toString()
    });
  }

  @override
  void onInit() {
    controllercoupon = TextEditingController();
    viewcart();
    super.onInit();
  }
}
