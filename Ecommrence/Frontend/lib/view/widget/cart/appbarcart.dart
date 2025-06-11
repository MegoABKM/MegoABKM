import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbarCart extends StatelessWidget {
  final String title;
  const CustomAppbarCart({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
            )),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
