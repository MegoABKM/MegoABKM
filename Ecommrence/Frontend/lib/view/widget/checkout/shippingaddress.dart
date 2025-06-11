import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';

class ShippingAddressInfo extends StatelessWidget {
  final String titleaddress;
  final String infoaddress;
  final bool isActive;
  const ShippingAddressInfo(
      {super.key,
      required this.titleaddress,
      required this.infoaddress,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive == true ? AppColor.thirdcolor : Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        child: ListTile(
          title: Text(
            titleaddress,
            style: TextStyle(
                color: isActive == true ? Colors.white : AppColor.black),
          ),
          subtitle: Text(
            infoaddress,
            style: TextStyle(
                color: isActive == true ? Colors.white : AppColor.black),
          ),
        ),
      ),
    );
  }
}
