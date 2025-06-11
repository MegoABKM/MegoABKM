import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class TextCheckOut extends StatelessWidget {
  final String title;
  const TextCheckOut({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: AppColor.primarycolor,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }
}
