import 'package:ecommrence/controller/items_controller.dart';
import 'package:ecommrence/controller/productdetails_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubItemsList extends GetView<ProductdetailsControllerImp> {
  const SubItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...List.generate(
        controller.subItems.length,
        (index) => Container(
          margin: const EdgeInsets.only(left: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: controller.subItems[index]['active'] == 1
                  ? AppColor.thirdcolor
                  : Colors.white,
              border: Border.all(color: AppColor.thirdcolor),
              borderRadius: BorderRadius.circular(10)),
          height: 60,
          width: 90,
          child: Text(
            "${controller.subItems[index]['name']}",
            style: TextStyle(
                color: controller.subItems[index]['active'] == 1
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      )
    ]);
  }
}
