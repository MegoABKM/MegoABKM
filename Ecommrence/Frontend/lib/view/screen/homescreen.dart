import 'package:ecommrence/controller/homescreen_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/home/custombottomappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomescreenControllerImp());
    return GetBuilder<HomescreenControllerImp>(
        builder: (controller) => Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColor.primarycolor,
                shape: const CircleBorder(),
                onPressed: () {
                  controller.goToCart();
                },
                child: const Icon(Icons.shopping_basket),
              ),
              bottomNavigationBar: const CustomBottomAppbar(),
              body: controller.listPage.elementAt(controller.currentpage),
            ));
  }
}
