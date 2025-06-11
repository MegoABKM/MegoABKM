import 'package:ecommrence/controller/home_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/core/functions/translatedatabase.dart';
import 'package:ecommrence/data/model/categoriesmodel.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomCategories extends GetView<HomeControllerImp> {
  const CustomCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.scaleConfig.scale(100),
        child: ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(width: context.scaleConfig.scale(10)),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) => Categories(
                categoriesModel:
                    CategoriesModel.fromJson(controller.categories[index]),
                index)));
  }
}

class Categories extends GetView<HomeControllerImp> {
  final CategoriesModel categoriesModel;
  final int i;
  const Categories(this.i, {super.key, required this.categoriesModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.goToItems(
          controller.categories, i, categoriesModel.categoriesId!),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: AppColor.secondcolor,
                  borderRadius:
                      BorderRadius.circular(context.scaleConfig.scale(20))),
              padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(10)),
              height: context.scaleConfig.scale(70),
              width: context.scaleConfig.scale(70),
              child: SvgPicture.network(
                '${AppLink.imagesCategories}/${categoriesModel.categoriesImage}',
                color: AppColor.thirdcolor,
              )),
          Text(
            "${translateDatabase(categoriesModel.categoriesNameAr, categoriesModel.categoriesName)}",
            style: TextStyle(
                fontSize: context.scaleConfig.scaleText(13),
                color: AppColor.black),
          )
        ],
      ),
    );
  }
}
