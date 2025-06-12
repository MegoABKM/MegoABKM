// Drawer with Sign-Out
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:schoolmanagement/core/constant/routes.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Text(
              'الإعدادات',
              style:
                  theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Get.find<StudentDashboardController>().supabase.auth.signOut();
              Get.offAllNamed(AppRoute.login);
            },
          ),
        ],
      ),
    );
  }
}
