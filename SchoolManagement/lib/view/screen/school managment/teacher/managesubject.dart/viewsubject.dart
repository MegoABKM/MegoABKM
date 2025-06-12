import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/viewsubject.dart';

class ViewSubjectsScreen extends StatelessWidget {
  final ViewSubjectsController controller = Get.put(ViewSubjectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض المواد'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.subjects.isEmpty) {
          return const Center(child: Text('لا توجد مواد متاحة'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.subjects[index];
            return Card(
              child: ListTile(
                title: Text(subject['subject_name']),
                subtitle: Text(
                    'المعلم: ${subject['teachers']['teacher_firstname']} ${subject['teachers']['teacher_lastname']}'),
              ),
            );
          },
        );
      }),
    );
  }
}
