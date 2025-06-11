import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomTitleHome extends StatelessWidget {
  final String title;
  const CustomTitleHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.scaleConfig.scale(10)),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: context.scaleConfig.tabletScaleText(18),
          color: AppColor.primarycolor,
        ),
      ),
    );
  }
}
