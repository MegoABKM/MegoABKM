import 'package:ecommrence/controller/address/viewanddeleteaddress_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      ViewAndDeleteAddressController(),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offNamed(
            AppRoute.addressAdd,
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: GetBuilder<ViewAndDeleteAddressController>(
        builder: (controller) {
          return Handlingdataview(
            statusRequest: controller.statusRequest,
            widget: ListView(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.addressinfo.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                Get.toNamed(AppRoute.addressUpdate, arguments: {
                                  "addressid":
                                      controller.addressinfo[index].addressId,
                                  "addressname":
                                      controller.addressinfo[index].addressName
                                });
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                controller.deteleAddress(controller
                                    .addressinfo[index].addressId
                                    .toString());
                              },
                              icon: const Icon(Icons.delete_forever))
                        ],
                      ),
                      subtitle: Text(
                          "${controller.addressinfo[index].addressCity} ${controller.addressinfo[index].addressStreet}"),
                      title:
                          Text("${controller.addressinfo[index].addressName}"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
