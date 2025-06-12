import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/homeschool_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';
import 'package:schoolmanagement/core/constant/routes.dart';
import 'package:schoolmanagement/main.dart';
import 'package:schoolmanagement/view/screen/school%20managment/sendmessage/sendmessage.dart';
import 'package:schoolmanagement/view/screen/school%20managment/subjectfile/subjectfiles.dart';

class SchoolHome extends StatelessWidget {
  const SchoolHome({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeschoolController());
    final theme = Theme.of(context);

    return GetBuilder<HomeschoolController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: const Text(
              'الرئيسية',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: AppThemes.defaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.schoolName}',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCountTile(
                            title: 'المواد',
                            count: controller.subjectCount,
                            color: theme.colorScheme.tertiary,
                          ),
                          _buildCountTile(
                            title: 'الطلاب',
                            count: controller.studentCount,
                            color: theme.colorScheme.tertiary,
                          ),
                          _buildCountTile(
                            title: 'الصفوف',
                            count: controller.classCount,
                            color: theme.colorScheme.tertiary,
                          ),
                          _buildCountTile(
                            title: 'المعلمون',
                            count: controller.teacherCount,
                            color: theme.colorScheme.tertiary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildCard(
                              icon: Icons.group,
                              title: 'الطلاب',
                              subtitle: 'معلومات الطلاب',
                              color: theme.colorScheme.tertiary,
                              onPressed: () =>
                                  Get.toNamed(AppRoute.studentmanagment),
                            ),
                            _buildCard(
                              icon: Icons.calendar_today,
                              title: 'الغيابات',
                              subtitle: 'الغياب والحضور',
                              color: theme.colorScheme.tertiary,
                              onPressed: () => Get.toNamed(AppRoute.absentPage),
                            ),
                            _buildCard(
                              icon: Icons.table_chart,
                              title: 'المعلمون والصفوف',
                              subtitle: 'تفاصيل المعلمين',
                              color: theme.colorScheme.tertiary,
                              onPressed: () =>
                                  Get.toNamed(AppRoute.teacherhomeschool),
                            ),
                            _buildCard(
                              icon: Icons.person,
                              title: 'ولي الأمر',
                              subtitle: 'معلومات ولي الأمر',
                              color: theme.colorScheme.tertiary,
                              onPressed: () =>
                                  Get.toNamed(AppRoute.gaurdianpage),
                            ),
                            _buildCard(
                              icon: Icons.book,
                              title: 'ملفات المواد',
                              subtitle: 'تحميل وعرض الملفات',
                              color: theme.colorScheme.tertiary,
                              onPressed: () =>
                                  Get.to(() => const SubjectFilesScreen()),
                            ),
                            _buildCard(
                              icon: Icons.message,
                              title: 'إرسال رسالة',
                              subtitle: 'إرسال رسالة للطلاب',
                              color: theme.colorScheme.tertiary,
                              onPressed: () =>
                                  Get.to(() => const SendMessageScreen()),
                            ),
                            _buildCard(
                              icon: Icons.logout,
                              title: 'تسجيل الخروج',
                              subtitle: '',
                              color: theme.colorScheme.tertiary,
                              onPressed: () {
                                myServices.sharedPreferences.clear();
                                Get.offAllNamed(AppRoute.login);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: AppThemes.defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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

  Widget _buildCountTile({
    required String title,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: color),
        ),
        const SizedBox(height: 5),
        Text(
          '$count',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
