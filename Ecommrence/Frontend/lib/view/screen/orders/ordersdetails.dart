import 'package:ecommrence/controller/orders/details_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    OrdersDetailsController controller = Get.put(OrdersDetailsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GetBuilder<OrdersDetailsController>(
            builder: (controller) => Handlingdataview(
              statusRequest: controller.statusRequest,
              widget: ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              const TableRow(children: [
                                Text(
                                  "Item",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: AppColor.primarycolor),
                                ),
                                Text("QTY",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.primarycolor)),
                                Text("Price",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: AppColor.primarycolor))
                              ]),
                              ...List.generate(
                                controller.orderdetailslist.length,
                                (index) => TableRow(children: [
                                  Text(
                                    "${controller.orderdetailslist[index].itemsName}",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${controller.orderdetailslist[index].itemsCount}",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${controller.orderdetailslist[index].itemsprice}",
                                    textAlign: TextAlign.center,
                                  )
                                ]),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                                "Price : ${controller.ordersModel!.ordersFullprice}\$",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.primarycolor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.ordersModel!.ordersType == 0)
                    Card(
                      child: Container(
                        child: ListTile(
                            title: Text("Shipping Address",
                                style: TextStyle(color: AppColor.primarycolor)),
                            subtitle: controller.markerPosition != null
                                ? Text(
                                    "${controller.ordersModel!.addressCity} ${controller.ordersModel!.addressStreet}  ")
                                : Center(child: Text("No Following Address"))),
                      ),
                    ),
                  if (controller.ordersModel!.ordersType == 0)
                    Card(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 300,
                          width: double.infinity,
                          child: controller.markerPosition != null
                              ? FlutterMap(
                                  mapController: controller.mapController,
                                  options: MapOptions(
                                    initialCenter: controller.markerPosition!,
                                    initialZoom: 15,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    if (controller.markerPosition != null)
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: controller.markerPosition!,
                                            width: 80,
                                            height: 80,
                                            child: const Icon(
                                              Icons.location_pin,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Center(child: Text("Not Delivery"))),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
