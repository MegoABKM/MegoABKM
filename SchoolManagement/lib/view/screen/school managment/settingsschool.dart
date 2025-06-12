// lib/screens/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/settingschool_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';

class SchoolSettingsPage extends StatelessWidget {
  const SchoolSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppThemes.defaultPadding,
        child: GetBuilder<SettingsController>(
          builder: (controller) {
            if (controller.isLoading && controller.schoolEmail == null) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.yellow,
              ));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اسم المدرسة',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.schoolNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'أدخل اسم المدرسة',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'البريد الإلكتروني',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.schoolEmail ?? 'غير متوفر',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'نوع التعليم',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.schoolLearnTypeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'أدخل نوع التعليم',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'عدد الطلاب',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${controller.studentCount}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          controller.isSaving ? null : controller.saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: controller.isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'حفظ التغييرات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
