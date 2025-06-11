import 'package:ecommrence/controller/productdetails_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceAndCountItems extends GetView<ProductdetailsControllerImp> {
  final void Function()? addPressed;
  final void Function()? removePressed;
  final String price;
  final String count;

  const PriceAndCountItems(
      {super.key,
      this.addPressed,
      this.removePressed,
      required this.price,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            IconButton(onPressed: addPressed, icon: const Icon(Icons.add)),
            Container(
              alignment: Alignment.center,
              width: 50,
              decoration: BoxDecoration(border: Border.all(width: 0)),
              child: Text(count),
            ),
            IconButton(onPressed: removePressed, icon: const Icon(Icons.remove))
          ],
        ),
        const Spacer(),
        Text(
          "$price.0\$",
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColor.thirdcolor),
        )
      ],
    );
  }
}
