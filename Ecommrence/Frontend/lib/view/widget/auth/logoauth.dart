import 'package:ecommrence/core/constant/imageasset.dart';
import 'package:flutter/material.dart';

class Logouth extends StatelessWidget {
  const Logouth({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImageAsset.logo,
      height: 170,
    );
  }
}
