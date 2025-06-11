import 'package:ecommrence/controller/productdetails_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/productdetails/priceandcount.dart';
import 'package:ecommrence/view/widget/productdetails/subitemslist.dart';
import 'package:ecommrence/view/widget/productdetails/toppageproductdetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ProductdetailsControllerImp controller =
        Get.put(ProductdetailsControllerImp());
    return Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 40,
          child: MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            color: AppColor.primarycolor,
            onPressed: () {
              controller.goToCart();
            },
            child: const Text(
              "Go To Cart",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: GetBuilder<ProductdetailsControllerImp>(
          builder: (controller) => ListView(children: [
            const TopPageProductDetails(),
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${controller.itemsModel.itemsName}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColor.thirdcolor)),
                  Text("${controller.itemsModel.itemsDesc}",
                      style: Theme.of(context).textTheme.bodyLarge!),
                  const SizedBox(
                    height: 10,
                  ),
                  Handlingdataview(
                    statusRequest: controller.statusRequest,
                    widget: PriceAndCountItems(
                        addPressed: () {
                          controller.add();
                        },
                        removePressed: () {
                          controller.remove();
                        },
                        price: "${controller.itemsModel.itemsPriceDiscount}",
                        count: controller.countitems.toString()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Color",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColor.thirdcolor)),
                  const SizedBox(
                    height: 10,
                  ),
                  const SubItemsList()
                ],
              ),
            )
          ]),
        ));
  }
}
