import 'package:ecommrence/controller/orders/pending_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/data/model/ordersmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class PendingOrders extends StatelessWidget {
  const PendingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PendingController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: GetBuilder<PendingController>(
                builder: (controller) => Handlingdataview(
                      statusRequest: controller.statusRequest,
                      widget: ListView.builder(
                        itemCount: controller.orders.length,
                        itemBuilder: (context, index) => CardOrderList(
                          listdata: controller.orders[index],
                        ),
                      ),
                    ))));
  }
}

class CardOrderList extends GetView<PendingController> {
  final OrdersModel listdata;
  const CardOrderList({super.key, required this.listdata});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Order Number : #${listdata.ordersId}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(Jiffy.parse('${listdata.ordersTime}').fromNow())
            ],
          ),
          const Divider(),
          Text(
            "Order Type : ${controller.printOrderType(listdata.ordersType.toString())}",
          ),
          Text(
            "Order Price : ${listdata.ordersPrice} \$",
          ),
          Text(
            "Delivery Price : ${listdata.ordersPricedelivery} \$",
          ),
          Text(
            "Payment Method : ${controller.printPaymentMethod(listdata.ordersPaymentmethod.toString())}",
          ),
          Text(
            "Order Status : ${controller.printOrderStatus(listdata.ordersStatus.toString())}",
          ),
          const Divider(),
          Row(
            children: [
              Text(
                "Total Price : ${listdata.ordersFullprice} \$",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.primarycolor),
              ),
              const Spacer(),
              MaterialButton(
                onPressed: () {
                  Get.toNamed(AppRoute.ordersdetails,
                      arguments: {"ordermodel": listdata});
                },
                color: AppColor.secondcolor,
                textColor: AppColor.thirdcolor,
                child: const Text("Details"),
              ),
              const SizedBox(
                width: 10,
              ),
              if (listdata.ordersStatus == 0)
                MaterialButton(
                  onPressed: () {
                    controller.deleteOrder(listdata.ordersId.toString());
                  },
                  color: AppColor.secondcolor,
                  textColor: AppColor.thirdcolor,
                  child: const Text("Delete"),
                ),
            ],
          )
        ],
      ),
    ));
  }
}
