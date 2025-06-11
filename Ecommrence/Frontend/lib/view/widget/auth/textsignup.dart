import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class CustomTextSignupOrSignin extends StatelessWidget {
  final String text;
  final String textbutton;

  final Function()? onTap;
  const CustomTextSignupOrSignin(
      {super.key, required this.text, this.onTap, required this.textbutton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        InkWell(
          onTap: onTap,
          child: Text(
            textbutton,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.primarycolor),
          ),
        ),
      ],
    );
  }
}
