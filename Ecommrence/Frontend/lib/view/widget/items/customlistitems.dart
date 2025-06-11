import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommrence/controller/favorite_controller.dart';
import 'package:ecommrence/controller/items_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/imageasset.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/core/functions/translatedatabase.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItems extends GetView<ItemsControllerImp> {
  final ItemsModel itemsModel;

  const CustomListItems({super.key, required this.itemsModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.goToPageProductDetails(itemsModel);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(context.scaleConfig.scale(10)),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch children horizontally
                children: [
                  Hero(
                    tag: "${itemsModel.itemsId}",
                    child: CachedNetworkImage(
                      imageUrl:
                          "${AppLink.imagesitems}/${itemsModel.itemsImage}",
                      // Scale image height
                      height: context.scaleConfig.scale(100),
                      // IMPORTANT: Change from .fill to .contain to prevent stretching
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: context.scaleConfig.scale(10),
                  ),
                  Text(
                    "${translateDatabase(itemsModel.itemsNameAr, itemsModel.itemsName)}",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: context.scaleConfig.scaleText(15),
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.scaleConfig.scale(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rating 3.5",
                        style: TextStyle(
                            color: AppColor.grey,
                            fontSize: context.scaleConfig.scaleText(12)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: context.scaleConfig.scale(5)),
                      ...List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                // Scale icon size
                                size: context.scaleConfig.scale(16),
                                color: Colors.amber,
                              ))
                    ],
                  ),
                  const Spacer(), // Use Spacer to push price/fav to the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${itemsModel.itemsPriceDiscount}\$",
                        style: TextStyle(
                            color: AppColor.primarycolor,
                            fontSize: context.scaleConfig.scaleText(16),
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans"),
                      ),
                      GetBuilder<FavoriteController>(
                        builder: (controller) => IconButton(
                            onPressed: () {
                              if (controller.isFavorite[itemsModel.itemsId] ==
                                  "1") {
                                controller.setFavorite(itemsModel.itemsId, "0");
                                controller.removeFavorite(
                                    itemsModel.itemsId.toString());
                              } else {
                                controller.setFavorite(itemsModel.itemsId, "1");
                                controller
                                    .addFavorite(itemsModel.itemsId.toString());
                              }
                            },
                            icon: Icon(
                                controller.isFavorite[itemsModel.itemsId] == "1"
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: AppColor.primarycolor)),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Position the sales banner
            if (itemsModel.itemsDiscount != 0)
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  AppImageAsset.sales,
                  width: context.scaleConfig.scale(50),
                ),
              )
          ],
        ),
      ),
    );
  }
}
