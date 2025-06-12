import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';
import 'package:schoolmanagement/core/constant/routes.dart';

class Studenthomemanagment extends StatelessWidget {
  const Studenthomemanagment({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          ' الطلاب',
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.appBarTheme.foregroundColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppThemes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إدارة الطلاب',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.colorScheme.secondary),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                      icon: Icons.person_add,
                      title: 'إضافة طالب',
                      subtitle: 'إضافة طالب جديد إلى النظام',
                      color: theme.colorScheme.tertiary,
                      onPressed: () {
                        Get.toNamed(AppRoute.addstudent);
                      }),
                  _buildCard(
                      icon: Icons.edit,
                      title: 'تحديث طالب',
                      subtitle: 'تعديل بيانات الطالب',
                      color: theme.colorScheme.tertiary,
                      onPressed: () {
                        Get.toNamed(AppRoute.updatestudent);
                      }),
                  _buildCard(
                      icon: Icons.visibility,
                      title: 'عرض الطلاب',
                      subtitle: 'عرض قائمة الطلاب',
                      color: theme.colorScheme.tertiary,
                      onPressed: () {
                        Get.toNamed(AppRoute.viewstudent);
                      }),
                  _buildCard(
                      icon: Icons.delete,
                      title: 'حذف طالب',
                      subtitle: 'حذف طالب من النظام',
                      color: theme.colorScheme.tertiary,
                      onPressed: () {
                        Get.toNamed(AppRoute.deletestudent);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required void Function() onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: AppThemes.defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
