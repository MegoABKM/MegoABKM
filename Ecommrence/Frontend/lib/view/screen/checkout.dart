import 'package:ecommrence/controller/checkout_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/imageasset.dart';
import 'package:ecommrence/view/widget/checkout/cardpaymentmethod.dart';
import 'package:ecommrence/view/widget/checkout/deliverytype.dart';
import 'package:ecommrence/view/widget/checkout/shippingaddress.dart';
import 'package:ecommrence/view/widget/checkout/textcheckout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    CheckoutController controller = Get.put(CheckoutController());
    return Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MaterialButton(
            color: AppColor.primarycolor,
            onPressed: () {
              controller.checkout();
            },
            child: const Text(
              "Checkout",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            "CheckOut",
          ),
        ),
        body: GetBuilder<CheckoutController>(
            builder: (controller) => Handlingdataview(
                  statusRequest: controller.statusRequest,
                  widget: Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        const TextCheckOut(title: "Choose Payment Methode"),
                        InkWell(
                          onTap: () {
                            // 0 for cash 1 for card
                            controller.choosePaymentMethod("0");
                          },
                          child: PaymentCardMethod(
                            nameMethod: "Cash",
                            isActive:
                                controller.paymentMethod == "0" ? true : false,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.choosePaymentMethod("1");
                          },
                          child: PaymentCardMethod(
                            nameMethod: "Payment Card",
                            isActive:
                                controller.paymentMethod == "1" ? true : false,
                          ),
                        ),
                        const TextCheckOut(title: "Choose Delivery Type"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                //0 delivery 1 for receive
                                controller.chooseDeleiveryType("0");
                              },
                              child: DeliveryType(
                                imageDelivery: AppImageAsset.delivery,
                                nameDelivery: "Delivery To Place",
                                isActive: controller.deliveryType == "0"
                                    ? true
                                    : false,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                controller.chooseDeleiveryType("1");
                              },
                              child: DeliveryType(
                                imageDelivery: AppImageAsset.receive,
                                nameDelivery: "Receive From Store",
                                isActive: controller.deliveryType == "1"
                                    ? true
                                    : false,
                              ),
                            ),
                          ],
                        ),
                        if (controller.deliveryType == "0")
                          Column(
                            children: [
                              const TextCheckOut(title: "Shipping Address"),
                              ...List.generate(
                                controller.addressinfo.length,
                                (index) => InkWell(
                                  onTap: () {
                                    controller.chooseShippingAddress(controller
                                        .addressinfo[index].addressId!
                                        .toString());
                                  },
                                  child: ShippingAddressInfo(
                                      titleaddress:
                                          "${controller.addressinfo[index].addressName}",
                                      infoaddress:
                                          "${controller.addressinfo[index].addressStreet}",
                                      isActive: controller.addressId ==
                                              controller
                                                  .addressinfo[index].addressId
                                                  .toString()
                                          ? true
                                          : false),
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                )));
  }
}
