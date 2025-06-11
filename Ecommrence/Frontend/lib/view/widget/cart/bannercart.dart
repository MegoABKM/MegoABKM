import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class BannerCart extends StatelessWidget {
  final String countOfCart;
  const BannerCart({super.key, required this.countOfCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColor.primarycolor,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        style: const TextStyle(color: Colors.white),
        countOfCart,
        textAlign: TextAlign.center,
      ),
    );
  }
}
