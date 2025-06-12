import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/viewstudent.dart';

class ViewStudentsScreen extends StatelessWidget {
  final ViewStudentsController controller = Get.put(ViewStudentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض الطلاب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshStudents(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.students.isEmpty) {
          return const Center(child: Text('لا يوجد طلاب لهذه المدرسة'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.students.length,
          itemBuilder: (context, index) {
            final student = controller.students[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  '${student['student_firstname']} ${student['student_lastname']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العمر: ${student['student_age']}'),
                    Text('المرحلة: ${student['student_stage']}'),
                    Text('البريد: ${student['student_email']}'),
                    Text('الهاتف: ${student['student_phonenumber']}'),
                  ],
                ),
                trailing: Text('ID: ${student['student_id']}'),
              ),
            );
          },
        );
      }),
    );
  }
}
