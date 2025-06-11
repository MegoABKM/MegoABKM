import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommrence/controller/myfavorite_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/functions/translatedatabase.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/data/model/myfavoritemodel.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFavoriteList extends GetView<MyFavoriteController> {
  final MyFavoriteModel myFavoriteModel;

  const CustomFavoriteList({super.key, required this.myFavoriteModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.goToPageProductDetails(itemsModel);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "${myFavoriteModel.itemsId}",
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${AppLink.imagesitems}/${myFavoriteModel.itemsImage}",
                    height: 100,
                    fit: BoxFit.fill,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${translateDatabase(myFavoriteModel.itemsNameAr, myFavoriteModel.itemsName)}",
              style: const TextStyle(color: AppColor.black, fontSize: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rating 3.5",
                  style: TextStyle(color: AppColor.black, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                          5,
                          (index) => const Icon(
                                Icons.star,
                                size: 15,
                              ))
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "${myFavoriteModel.itemsPrice}\$",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 59, 223, 34),
                        fontSize: 15,
                        fontFamily: "sans"),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      controller
                          .removeData(myFavoriteModel.favoriteId.toString());
                    },
                    icon: const Icon(Icons.delete_outline_outlined)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
