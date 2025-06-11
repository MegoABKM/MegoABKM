import 'package:ecommrence/controller/cart_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/cart/buttoncart.dart';
import 'package:ecommrence/view/widget/cart/custombuttoncoupon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtomBarCart extends GetView<CartController> {
  final String price;
  final String discount;
  final String totalprice;
  final String shipping;

  final TextEditingController controllercoupon;
  final void Function()? onPressedPlaceOrder;
  final void Function()? onPressedCoupon;

  const ButtomBarCart(
      {super.key,
      required this.price,
      required this.discount,
      required this.totalprice,
      this.onPressedPlaceOrder,
      required this.controllercoupon,
      this.onPressedCoupon,
      required this.shipping});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<CartController>(
              builder: (controller) => controller.couponname == null
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: controllercoupon,
                              decoration: const InputDecoration(
                                hintText: "Coupon Code",
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 1,
                              child: CustomButtonCoupon(
                                textbutton: "Check",
                                onPressed: onPressedCoupon,
                              ))
                        ],
                      ),
                    )
                  : Container(
                      child: Text(
                        controller.couponname!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primarycolor),
                      ),
                    )),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Price :",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$price\$",
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Discount :",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          discount,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Shipping :",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "${shipping}\$",
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: const Divider(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Total price :",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$totalprice\$",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.green),
                        ),
                      )
                    ],
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          CustomButtonCart(
            textbutton: "Place Order",
            onPressed: onPressedPlaceOrder,
          ),
        ],
      ),
    );
  }
}
