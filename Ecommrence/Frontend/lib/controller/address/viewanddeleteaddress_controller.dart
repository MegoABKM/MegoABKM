import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/address_data.dart';
import 'package:ecommrence/data/model/addressmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ViewAndDeleteAddressController extends GetxController {
  List<AddressModel> addressinfo = [];
  StatusRequest? statusRequest;
  AddressData addressData = AddressData(Get.find());
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
    viewAddress();
  }

  viewAddress() async {
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

  deteleAddress(String addressid) async {
    var response = await addressData.removeAddress(addressid);
    addressinfo.removeWhere((e) => e.addressId.toString() == addressid);
    Get.rawSnackbar(messageText: const Text("Deleted From Address"));
    update();
  }
}
