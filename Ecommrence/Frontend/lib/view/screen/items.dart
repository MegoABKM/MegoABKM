import 'package:ecommrence/controller/favorite_controller.dart';
import 'package:ecommrence/controller/items_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/view/widget/home/customappbar.dart';
import 'package:ecommrence/view/widget/home/customsearchitems.dart';
import 'package:ecommrence/view/widget/items/customlistitems.dart';
import 'package:ecommrence/view/widget/items/listcategoriesitems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ItemsControllerImp controller = Get.put(ItemsControllerImp());
    FavoriteController favoriteController = Get.put(FavoriteController());
    return Scaffold(
      body: Container(
          // Make main container padding responsive
          padding: EdgeInsets.all(context.scaleConfig.scale(15)),
          child: ListView(children: [
            CustomAppBar(
              // Assuming CustomAppBar is already responsive
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
            SizedBox(
              // Make vertical spacing responsive
              height: context.scaleConfig.scale(15),
            ),
            const ListCategoriesItems(),
            GetBuilder<ItemsControllerImp>(
                builder: (controller) => Handlingdataview(
                    statusRequest: controller.statusRequest,
                    widget: controller.isSearch
                        ? SearchList(
                            searchResult: controller.searchResult,
                            onTap: () {
                              controller.goToPageProductDetails(
                                  controller.searchedconverted);
                            },
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // The aspect ratio can often remain constant as the content inside scales.
                            // This maintains the overall shape of the grid items.
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.66,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemCount: controller.items.length,
                            itemBuilder: (context, index) {
                              favoriteController.isFavorite[
                                      controller.items[index]["items_id"]] =
                                  controller.items[index]["favorite"]
                                      .toString();
                              return CustomListItems(
                                itemsModel: ItemsModel.fromJson(
                                  controller.items[index],
                                ),
                              );
                            })))
          ])),
    );
  }
}
