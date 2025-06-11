import 'package:ecommrence/controller/orders/pending_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

requestPermissionNotification() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
}

fcmconfig() {
  FirebaseMessaging.onMessage.listen(
    (message) {
      print("Notification================");
      print(message.notification!.title);
      print(message.notification!.body);
      FlutterRingtonePlayer().playNotification();
      Get.snackbar(message.notification!.title!, message.notification!.body!,
          backgroundColor: Colors.green);
      refreshPageNotification(message.data);
    },
  );
}

void refreshPageNotification(data) {
  print("=================== page id ");
  print(data["pageid"]);
  print("=================== page name ");
  print(data["pagename"]);
  print(Get.currentRoute);

  if (Get.currentRoute == "/orders" && data["pagename"] == "orders") {
    PendingController controller = Get.find();

    controller.refreshOrder();
  }
}
