import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final String textbutton;
  final void Function()? onPressed;
  const CustomButtonAuth({super.key, required this.textbutton, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        color: AppColor.primarycolor,
        onPressed: onPressed,
        child: Text(
          textbutton,
        ),
      ),
    );
  }
}
