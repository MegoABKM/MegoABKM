import 'package:ecommrence/controller/items_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/core/functions/translatedatabase.dart';
import 'package:ecommrence/data/model/categoriesmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCategoriesItems extends GetView<ItemsControllerImp> {
  const ListCategoriesItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // Scale the height of the list
        height: context.scaleConfig.scale(50),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  // Scale the spacing between items
                  width: context.scaleConfig.scale(15),
                ),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) => Categories(
                categoriesModel:
                    CategoriesModel.fromJson(controller.categories[index]),
                i: index)));
  }
}

class Categories extends GetView<ItemsControllerImp> {
  final CategoriesModel categoriesModel;
  final int i;
  const Categories({super.key, required this.categoriesModel, required this.i});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.changeCat(i, categoriesModel.categoriesId!);
      },
      child: Column(
        children: [
          GetBuilder<ItemsControllerImp>(
            builder: (controller) => Container(
              padding: EdgeInsets.only(bottom: context.scaleConfig.scale(5)),
              decoration: controller.selectedCat == i
                  ? BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              // Scale the border thickness
                              width: context.scaleConfig.scale(3),
                              color: AppColor.primarycolor)))
                  : null,
              child: Text(
                "${translateDatabase(categoriesModel.categoriesNameAr, categoriesModel.categoriesName)}",
                style: TextStyle(
                    // Scale the font size
                    fontSize: context.scaleConfig.scaleText(18),
                    color: controller.selectedCat == i
                        ? AppColor.primarycolor
                        : AppColor.grey,
                    fontWeight: controller.selectedCat == i
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
          )
        ],
      ),
    );
  }
}
