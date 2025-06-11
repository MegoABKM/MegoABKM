import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/constant/imageasset.dart';
import 'package:ecommrence/core/functions/checkinternet.dart';
import 'package:ecommrence/view/widget/auth/custombuttonauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HandlingDataAuthview extends StatelessWidget {
  final StatusRequest? statusRequest;
  final Widget widget;
  const HandlingDataAuthview(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: LottieBuilder.asset(
                  AppImageAsset.loading,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Loading...")
            ],
          )
        : statusRequest == StatusRequest.serverfailure
            ? Center(child: Lottie.asset(AppImageAsset.servererror))
            : statusRequest == StatusRequest.offlinefailure
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AppImageAsset.offline,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButtonAuth(
                        textbutton: "Refresh",
                        onPressed: () async {
                          if (await checkInternet()) {
                            Get.offAllNamed('/');
                          } else {
                            Get.defaultDialog(
                                title: "warning",
                                middleText: "No Internet Connection");
                          }
                        },
                      )
                    ],
                  ))
                : statusRequest == StatusRequest.serverExeption
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                                child: Lottie.asset(AppImageAsset.servererror,
                                    fit: BoxFit.cover)),
                          ),
                          const Text("Server Error , Page Not Found")
                        ],
                      )
                    : widget;
  }
}
