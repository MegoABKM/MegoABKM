import 'package:ecommrence/controller/homescreen_controller.dart';
import 'package:ecommrence/core/constant/color.dart';
import 'package:ecommrence/view/widget/home/custombuttonappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomescreenControllerImp>(
        builder: (controller) => BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Row(
                children: [
                  ...List.generate(
                    controller.listPage.length + 1,
                    (index) {
                      int changer = index > 2 ? index - 1 : index;
                      return index == 2
                          ? const Spacer()
                          : CustomButtonAppbar(
                              active: controller.currentpage == changer
                                  ? true
                                  : false,
                              colorItemSelected: AppColor.primarycolor,
                              iconButtomAppBar: controller.bottomappbar[changer]
                                  ['icon'],
                              titleButtomAppBar:
                                  controller.bottomappbar[changer]['title'],
                              onPressed: () {
                                controller.changePage(changer);
                              },
                            );
                    },
                  ),
                ],
              ),
            ));
  }
}
