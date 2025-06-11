import 'package:ecommrence/controller/home_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/view/widget/home/customappbar.dart';
import 'package:ecommrence/view/widget/home/customcardhome.dart';
import 'package:ecommrence/view/widget/home/customcategories.dart';
import 'package:ecommrence/view/widget/home/customitems.dart';
import 'package:ecommrence/view/widget/home/customsearchitems.dart';
import 'package:ecommrence/view/widget/home/customtitlehome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeControllerImp());

    return GetBuilder<HomeControllerImp>(
      builder: (controller) => Container(
        // Use the extension directly
        padding: EdgeInsets.symmetric(
            horizontal: context.scaleConfig.scale(15),
            vertical: context.scaleConfig.scale(10)),
        child: ListView(
          children: [
            CustomAppBar(
              onChanged: (val) {
                controller.checkSearch(val);
              },
              searchController: controller.search!,
              textAppBar: "Find Product",
              onPressedSearch: () {
                controller.onSearchItems();
                controller.searchData(controller.search!.text);
              },
              onPressedFavorite: () {
                Get.toNamed(AppRoute.myFavorite);
              },
            ),
            Handlingdataview(
              statusRequest: controller.statusRequest,
              widget: controller.isSearch
                  ? SearchList(
                      searchResult: controller.searchResult,
                      onTap: () {
                        controller.goToPageProductDetails(
                            controller.searchedconverted);
                      },
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCardHome(
                            title: 'A summer surprise', body: "Cashback 30%"),
                        CustomTitleHome(title: "Categories"),
                        CustomCategories(),
                        CustomTitleHome(title: "Product For You"),
                        CustomItems()
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
