import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';
import 'package:schoolmanagement/core/constant/routes.dart';

class Teacherhomemanagment extends StatelessWidget {
  const Teacherhomemanagment({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'المعلمون',
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
              'إدارة المعلمين',
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
                    title: 'إضافة معلم',
                    subtitle: 'إضافة معلم جديد إلى النظام',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.addteacher),
                  ),
                  _buildCard(
                    icon: Icons.edit,
                    title: 'تحديث معلم',
                    subtitle: 'تعديل بيانات المعلم',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.updateteacher),
                  ),
                  _buildCard(
                    icon: Icons.visibility,
                    title: 'عرض المعلمين',
                    subtitle: 'عرض قائمة المعلمين',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.viewteachers),
                  ),
                  _buildCard(
                    icon: Icons.delete,
                    title: 'حذف معلم',
                    subtitle: 'حذف معلم من النظام',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.deleteteacher),
                  ),
                  _buildCard(
                    icon: Icons.book,
                    title: 'إضافة مادة',
                    subtitle: 'إضافة مادة جديدة للمعلم',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.addsubject),
                  ),
                  _buildCard(
                    icon: Icons.bookmark_outline_outlined,
                    title: 'تحديث مادة',
                    subtitle: 'تحديث مادة ',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.updatesubject),
                  ),
                  _buildCard(
                    icon: Icons.bookmarks,
                    title: 'عرض مواد',
                    subtitle: ' عرض مادة او مواد',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.viewsubject),
                  ),
                  _buildCard(
                    icon: Icons.bookmark_remove_rounded,
                    title: 'حذف مادة',
                    subtitle: 'حذف مادة',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.deletesubject),
                  ),
                  _buildCard(
                    icon: Icons.table_view,
                    title: 'مشاهدة الجداول',
                    subtitle: '',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.viewtimetable),
                  ),
                  _buildCard(
                    icon: Icons.table_view,
                    title: 'انشاء الجداول',
                    subtitle: '',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.createtablesubject),
                  ),
                  _buildCard(
                    icon: Icons.create,
                    title: 'انشاء صف',
                    subtitle: '',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.createclass),
                  ),
                  _buildCard(
                    icon: Icons.class_,
                    title: 'مشاهدة الصفوف ',
                    subtitle: '',
                    color: theme.colorScheme.tertiary,
                    onPressed: () => Get.toNamed(AppRoute.viewclasses),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required void Function() onPressed,
  }) {
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
