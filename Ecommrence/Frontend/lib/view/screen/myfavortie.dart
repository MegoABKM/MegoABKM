import 'package:ecommrence/controller/myfavorite_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/view/widget/home/customappbar.dart';
import 'package:ecommrence/view/widget/myfavorite/customfavoritelist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFavortie extends StatelessWidget {
  const MyFavortie({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyFavoriteController());
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GetBuilder<MyFavoriteController>(
          builder: (controller) => ListView(
            children: [
              // CustomAppBar(
              //     textAppBar: "Find Product", onPressedFavorite: () {}),
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: Handlingdataview(
                statusRequest: controller.statusRequest,
                widget: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.7, crossAxisCount: 2),
                    itemCount: controller.data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => CustomFavoriteList(
                        myFavoriteModel: controller.data[index])),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
