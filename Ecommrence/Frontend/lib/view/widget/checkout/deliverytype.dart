import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class DeliveryType extends StatelessWidget {
  final String imageDelivery;
  final String nameDelivery;
  final bool isActive;
  const DeliveryType(
      {super.key,
      required this.imageDelivery,
      required this.nameDelivery,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          color: isActive == true ? AppColor.thirdcolor : null,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.primarycolor)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(imageDelivery,
              width: 120, height: 100, fit: BoxFit.fill),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(nameDelivery,
            style: TextStyle(
                color: isActive == true ? Colors.white : AppColor.thirdcolor,
                height: 1,
                fontWeight: FontWeight.bold))
      ]),
    );
  }
}
