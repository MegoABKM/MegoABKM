import 'package:ecommrence/controller/home_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCardHome extends GetView<HomeControllerImp> {
  final String title;
  final String body;
  const CustomCardHome({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.scaleConfig.scale(15)),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(context.scaleConfig.scale(20)),
              color: AppColor.primarycolor,
            ),
            height: context.scaleConfig.scale(150),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.scaleConfig.tabletScaleText(20),
                ),
              ),
              subtitle: Text(
                body,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.scaleConfig.tabletScaleText(30),
                ),
              ),
            ),
          ),
          Positioned(
            top: context.scaleConfig.scale(-20),
            right:
                controller.lang == "en" ? context.scaleConfig.scale(-20) : null,
            left:
                controller.lang == "ar" ? context.scaleConfig.scale(-20) : null,
            child: Container(
              height: context.scaleConfig.scale(160),
              width: context.scaleConfig.scale(160),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(context.scaleConfig.scale(160)),
                  color: AppColor.secondcolor),
            ),
          )
        ],
      ),
    );
  }
}
