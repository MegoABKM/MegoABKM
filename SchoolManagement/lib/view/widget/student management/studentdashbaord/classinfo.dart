// Class Information Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';

class ClassInfoWidget extends StatelessWidget {
  const ClassInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فصلك الدراسي',
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 10),
        if (controller.classDetails != null) ...[
          Text(
            'اسم الفصل: ${controller.classDetails!['class_name'] ?? 'غير محدد'}',
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            'الموقع: ${controller.classDetails!['place'] ?? 'غير محدد'}',
            style: theme.textTheme.bodyLarge,
          ),
        ] else
          const Text('لا توجد بيانات للفصل'),
      ],
    );
  }
}
