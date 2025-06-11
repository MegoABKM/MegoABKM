import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonAppbar extends StatelessWidget {
  final void Function()? onPressed;
  final IconData iconButtomAppBar;
  final String? titleButtomAppBar;
  final Color colorItemSelected;
  bool active = false;
  CustomButtonAppbar(
      {super.key,
      required this.onPressed,
      required this.iconButtomAppBar,
      required this.titleButtomAppBar,
      required this.colorItemSelected,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 30,
            iconButtomAppBar,
            color: active == true ? colorItemSelected : AppColor.black,
          ),
          // Text(
          //   titleButtomAppBar!,
          //   style: TextStyle(
          //     color: active == true ? colorItemSelected : AppColor.grey,
          //   ),
          // )
        ],
      ),
    );
  }
}
