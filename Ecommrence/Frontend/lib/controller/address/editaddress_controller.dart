import 'dart:async';
import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/functions/handlingdatacontroller.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/data/datasource/remote/address_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class EditAddressController extends GetxController {
  AddressData addressData = AddressData(Get.find());
  final MapController mapController = MapController();
  LatLng? markerPosition;
  String? streetName;
  String? cityName;
  String? lat;
  String? long;
  int? addressid;
  String? addressname;
  late TextEditingController nameLocation;
  MyServices myServices = Get.find();
  StatusRequest? statusRequest;

  editAddress() async {
    if (lat == null ||
        long == null ||
        cityName == null ||
        streetName == null ||
        nameLocation.text.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: "Incomplete data",
        message: "Please make sure all fields are filled.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    statusRequest = StatusRequest.loading;
    update();
    var response = await addressData.editAddress(
      addressid.toString(),
      myServices.sharedPreferences.getString("id")!,
      nameLocation.text,
      lat!,
      long!,
      cityName!,
      streetName!,
    );
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      if (response['status'] == "success") {
        goToViewpage();
      } else {
        statusRequest = StatusRequest.failure;
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: "Error",
        message: "Failed to add address. Please try again.",
        duration: Duration(seconds: 2),
      ));
    }
    update();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    lat = position.latitude.toString();
    long = position.longitude.toString();
    markerPosition = LatLng(position.latitude, position.longitude);
    await updateAddressDetails(markerPosition!);
    mapController.move(markerPosition!, 15);
    update();
  }

  Future<void> setMarkerPosition(LatLng newPosition) async {
    markerPosition = newPosition;
    lat = newPosition.latitude.toString();
    long = newPosition.longitude.toString();
    await updateAddressDetails(newPosition);
    update();
  }

  Future<void> updateAddressDetails(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        streetName = place.street;
        cityName = place.locality;
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  goToViewpage() {
    Get.offNamedUntil(
      AppRoute.addressView,
      (route) => false,
    );
  }

  @override
  void onInit() {
    getCurrentLocation();
    nameLocation = TextEditingController();
    addressname = Get.arguments['addressname'];
    addressid = Get.arguments["addressid"];
    super.onInit();
  }

  @override
  void onClose() {
    nameLocation.dispose();
    super.onClose();
  }
}
