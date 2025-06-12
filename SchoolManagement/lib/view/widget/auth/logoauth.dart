import 'package:flutter/material.dart';
import 'package:schoolmanagement/core/constant/imageasset.dart';

class Logouth extends StatelessWidget {
  const Logouth({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImageAsset.logo,
      height: 175,
    );
  }
}
