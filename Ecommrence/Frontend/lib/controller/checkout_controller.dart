import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/address_data.dart';
import 'package:ecommrence/data/datasource/remote/checkout_data.dart';
import 'package:ecommrence/data/model/addressmodel.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  AddressData addressData = Get.put(AddressData(Get.find()));
  List<AddressModel> addressinfo = [];
  late String couponid;
  late String priceorder;
  String? discountcoupon = "0";
  MyServices myServices = Get.find();
  String? paymentMethod;
  String addressId = "0";
  String? deliveryType;

  StatusRequest statusRequest = StatusRequest.none;

  CheckoutData checkoutData = CheckoutData(Get.find());

  choosePaymentMethod(String val) {
    paymentMethod = val;
    update();
  }

  chooseDeleiveryType(String val) {
    deliveryType = val;
    print(" delivery type is $deliveryType");
    update();
  }

  chooseShippingAddress(String val) {
    addressId = val;
    update();
  }

  getShippingAddress() async {
    {
      addressinfo.clear();
      statusRequest = StatusRequest.loading;
      update();

      var response = await addressData
          .viewAddress(myServices.sharedPreferences.getString("id")!);

      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        if (response['status'] == "success") {
          List dataResponse = response['data'];
          addressinfo.addAll(dataResponse.map((e) => AddressModel.fromJson(e)));
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
      update();
    }
  }

  checkout() async {
    print("Payment Method: $paymentMethod");
    print("Delivery Type: $deliveryType"); // Add this line to debug
    if (paymentMethod == null) {
      Get.snackbar("Error", "Add A Payment Method");
      return;
    }
    if (deliveryType == null) {
      Get.snackbar("Error", "Choose Order Type");
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    Map data = {
      "usersid": myServices.sharedPreferences.getString("id"),
      "useraddressid": addressId.toString(),
      "orderstype": deliveryType.toString(),
      "pricedelivery": "10",
      "ordersprice": priceorder,
      "couponid": couponid,
      "coupondiscount": discountcoupon.toString(),
      "paymentmethod": paymentMethod.toString()
    };

    var response = await checkoutData.checkOut(data);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      if (response['status'] == "success") {
        Get.offAllNamed(AppRoute.home);
        Get.snackbar("Success", "Successfully Ordered");
      } else {
        statusRequest = StatusRequest.none;
        Get.snackbar("Error", "Please Try Again");
      }
    } else {
      print("=======$response");

      statusRequest = StatusRequest.none;
      Get.snackbar("Error", "Uknown Error");
    }

    update();
  }

  @override
  void onInit() {
    getShippingAddress();
    couponid = Get.arguments['couponid'];
    priceorder = Get.arguments['totalprice'];
    discountcoupon = Get.arguments['coupondiscount'];
    super.onInit();
  }
}
