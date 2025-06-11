import 'package:ecommrence/core/constant/routes.dart';
import 'package:ecommrence/view/screen/home.dart';
import 'package:ecommrence/view/screen/notification.dart';
import 'package:ecommrence/view/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

abstract class HomeScreenController extends GetxController {
  changePage(int currentpage);
}

class HomescreenControllerImp extends HomeScreenController {
  int currentpage = 0;
  List<Widget> listPage = [
    const Home(),
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("profile"),
        )
      ],
    ),
    const NotificationView(),
    const Settings()
  ];

  List bottomappbar = [
    {"title": "Home", "icon": Icons.home_outlined},
    {"title": "Profile", "icon": Icons.person_2_outlined},
    {"title": "Notification", "icon": Icons.notifications_outlined},
    {"title": "Settings", "icon": Icons.settings_outlined}
  ];

  goToCart() {
    Get.toNamed(AppRoute.cart);
  }

  @override
  changePage(int i) {
    currentpage = i;
    print("current page ============= $currentpage");
    update();
  }
}
