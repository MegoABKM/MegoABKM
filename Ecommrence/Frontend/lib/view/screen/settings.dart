import 'package:ecommrence/controller/settings_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/core/constant/imageasset.dart';
import 'package:ecommrence/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController controller = SettingsController();
    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(height: Get.width / 2, color: AppColor.primarycolor),
            Positioned(
                top: Get.width / 2.5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(AppImageAsset.profile),
                  ),
                )),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            clipBehavior: Clip.none,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {},
                  trailing: Switch(
                      inactiveTrackColor: Colors.red,
                      activeColor: Colors.green,
                      onChanged: (value) {},
                      value: true),
                  title: const Text("Disable notification"),
                ),
                ListTile(
                  onTap: () {
                    Get.toNamed(AppRoute.orders);
                  },
                  trailing: const Icon(Icons.card_travel_outlined),
                  title: const Text("Orders"),
                ),
                ListTile(
                  onTap: () {
                    Get.toNamed(AppRoute.ordersarchived);
                  },
                  trailing: const Icon(Icons.archive),
                  title: const Text("Archived"),
                ),
                ListTile(
                  onTap: () {
                    Get.toNamed(AppRoute.addressView);
                  },
                  trailing: const Icon(Icons.edit_location),
                  title: const Text("Address"),
                ),
                ListTile(
                  onTap: () {},
                  trailing: const Icon(Icons.info),
                  title: const Text("About app"),
                ),
                ListTile(
                  trailing: const Icon(Icons.phone),
                  onTap: () async{
                    await launchUrl(Uri.parse("tel:+1-555-010-999"));
                  },
                  title: const Text("Contact us"),
                ),
                ListTile(
                  onTap: () {
                    controller.logout();
                  },
                  trailing: const Icon(Icons.exit_to_app),
                  title: const Text("Logout"),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
