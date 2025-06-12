import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/deletesubject.dart';

class DeleteSubjectScreen extends StatelessWidget {
  final DeleteSubjectController controller = Get.put(DeleteSubjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف مادة'),
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'تأكيد الحذف',
                      middleText:
                          'هل أنت متأكد من حذف ${subject['subject_name']}؟',
                      onConfirm: () {
                        controller.deleteSubject(subject['subject_id']);
                        Get.back();
                      },
                      onCancel: () => Get.back(),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
