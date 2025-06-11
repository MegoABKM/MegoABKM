import 'package:ecommrence/controller/notification_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return GetBuilder<NotificationController>(
      builder: (controller) => Handlingdataview(
          statusRequest: controller.statusRequest,
          widget: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const Center(
                    child: Text(
                  "Notifcation",
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColor.primarycolor,
                      fontWeight: FontWeight.bold),
                )),
                ...List.generate(
                  controller.notificaitonlist.length,
                  (index) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "${controller.notificaitonlist[index]["notification_title"]}"),
                      subtitle: Text(
                          "${controller.notificaitonlist[index]["notification_body"]}"),
                      trailing: Text(
                        Jiffy.parse(
                                "${controller.notificaitonlist[index]["notification_datetime"]}")
                            .fromNow(),
                        style: const TextStyle(
                            color: AppColor.primarycolor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
