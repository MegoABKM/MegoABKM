import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/viewteacher.dart';

class ViewTeachersScreen extends StatelessWidget {
  final ViewTeachersController controller = Get.put(ViewTeachersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض المعلمين'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.teachers.isEmpty) {
          return const Center(child: Text('لا يوجد معلمون'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.teachers.length,
          itemBuilder: (context, index) {
            final teacher = controller.teachers[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${teacher['teacher_firstname']} ${teacher['teacher_lastname']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('البريد: ${teacher['teacher_email'] ?? 'غير محدد'}'),
                    Text(
                        'الهاتف: ${teacher['teacher_phonenumber'] ?? 'غير محدد'}'),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
