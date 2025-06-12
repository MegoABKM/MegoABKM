// Teachers Button Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/view/screen/student%20managemnt/teacherpage.dart';

class TeachersButtonWidget extends StatelessWidget {
  const TeachersButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () => Get.to(() => const TeachersPage()),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('التواصل مع المعلمين'),
    );
  }
}
