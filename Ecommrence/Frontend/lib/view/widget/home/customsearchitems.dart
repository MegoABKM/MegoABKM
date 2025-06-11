import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommrence/controller/favorite_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/core/functions/translatedatabase.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchList extends StatelessWidget {
  final List<ItemsModel> searchResult;
  final void Function()? onTap;

  const SearchList({super.key, required this.searchResult, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.66, crossAxisCount: 2),
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: onTap,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "${searchResult[index].itemsId}",
                    child: Container(
                        padding: EdgeInsets.all(context.scaleConfig.scale(10)),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${AppLink.imagesitems}/${searchResult[index].itemsImage}",
                          height: context.scaleConfig.scale(100),
                          fit: BoxFit.contain,
                        )),
                  ),
                  SizedBox(
                    height: context.scaleConfig.scale(5),
                  ),
                  Text(
                    "${translateDatabase(searchResult[index].itemsNameAr, searchResult[index].itemsName)}",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: context.scaleConfig.scaleText(15)),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Rating 3.5",
                        style: TextStyle(color: AppColor.black, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          ...List.generate(
                              5,
                              (index) => Icon(
                                    Icons.star,
                                    size: context.scaleConfig.scale(15),
                                  ))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: context.scaleConfig.scale(8)),
                        child: Text(
                          "${searchResult[index].itemsPrice}\$",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 59, 223, 34),
                              fontSize: context.scaleConfig.scaleText(15),
                              fontFamily: "sans"),
                        ),
                      ),
                      GetBuilder<FavoriteController>(
                        init: FavoriteController(),
                        builder: (controller) => IconButton(
                            onPressed: () {
                              if (controller.isFavorite[
                                      searchResult[index].itemsId] ==
                                  "1") {
                                controller.setFavorite(
                                    searchResult[index].itemsId, "0");
                                controller.removeFavorite(
                                    searchResult[index].itemsId.toString());
                              } else {
                                controller.setFavorite(
                                    searchResult[index].itemsId, "1");
                                controller.addFavorite(
                                    searchResult[index].itemsId.toString());
                              }
                            },
                            icon: controller.isFavorite[
                                        searchResult[index].itemsId] ==
                                    "1"
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border_outlined)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
