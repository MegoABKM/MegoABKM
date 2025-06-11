import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommrence/controller/productdetails_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopPageProductDetails extends GetView<ProductdetailsControllerImp> {
  const TopPageProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
              color: AppColor.primarycolor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        Positioned(
          top: 40,
          right: Get.width / 8,
          left: Get.width / 8,
          child: Hero(
            tag: "${controller.itemsModel.itemsId}",
            child: CachedNetworkImage(
              imageUrl:
                  "${AppLink.imagesitems}/${controller.itemsModel.itemsImage}",
              height: 250,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
