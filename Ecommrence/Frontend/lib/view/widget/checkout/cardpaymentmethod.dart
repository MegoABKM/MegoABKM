import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class PaymentCardMethod extends StatelessWidget {
  final String nameMethod;
  final bool isActive;
  const PaymentCardMethod(
      {super.key, required this.nameMethod, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: isActive == true ? AppColor.thirdcolor : Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Text(nameMethod,
          style: TextStyle(
              color: isActive == true ? Colors.white : Colors.black,
              height: 1,
              fontWeight: FontWeight.bold)),
    );
  }
}
