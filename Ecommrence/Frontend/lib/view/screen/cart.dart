import 'package:ecommrence/controller/cart_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/view/widget/cart/bannercart.dart';
import 'package:ecommrence/view/widget/cart/buttombarcart.dart';
import 'package:ecommrence/view/widget/cart/cartitems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Cart"),
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (controller) => ButtomBarCart(
            controllercoupon: controller.controllercoupon!,
            onPressedCoupon: () {
              controller.checkCoupon();
            },
            price: "${controller.convertedpriceorder()}",
            discount: "${controller.discountcoupon}%",
            totalprice: " ${controller.getTotalPrice()}",
            onPressedPlaceOrder: () {
              controller.goToCheckout();
            },
            shipping: "10",
          ),
        ),
        body: GetBuilder<CartController>(
            builder: (controller) => Handlingdataview(
                  statusRequest: controller.statusRequest,
                  widget: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      BannerCart(
                          countOfCart:
                              "You have ${controller.totalcountitems} items in Your cart"),
                      ...List.generate(
                        controller.data.length,
                        (index) => CartItems(
                            minuscountitem: () async {
                              await controller.removeCartItem(
                                  controller.data[index].itemsId!.toString());
                              controller.refreshPage();
                            },
                            pluscountitem: () async {
                              await controller.addCartItem(
                                  controller.data[index].itemsId!.toString());
                              controller.refreshPage();
                            },
                            cartImage: "${controller.data[index].itemsImage}",
                            cartName: "${controller.data[index].itemsName}",
                            cartPrice: "${controller.data[index].itemsprice}",
                            count: "${controller.data[index].countitems}"),
                      )
                    ],
                  ),
                )));
  }
}
