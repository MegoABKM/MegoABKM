// lib/screens/class_students_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/classmanagement/crudclass_controller.dart';

class ClassStudentsPage extends StatelessWidget {
  final int classId;

  const ClassStudentsPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.find<ClassController>();
    final TextEditingController studentIdController = TextEditingController();

    controller.fetchStudentsInClass(classId);

    return GetBuilder<ClassController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('طلاب الصف')),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: controller.students.isEmpty
                          ? const Center(
                              child: Text('لا توجد طلاب في هذا الصف'))
                          : ListView.builder(
                              itemCount: controller.students.length,
                              itemBuilder: (context, index) {
                                final student = controller.students[index];
                                return ListTile(
                                  title: Text(
                                      '${student['student_firstname']} ${student['student_lastname']}'),
                                  subtitle:
                                      Text('ID: ${student['student_id']}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _confirmDelete(
                                        context, student['student_id']),
                                  ),
                                  onTap: () =>
                                      _showStudentDetails(context, student),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: studentIdController,
                              decoration: const InputDecoration(
                                  labelText: 'معرف الطالب'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              final studentId =
                                  int.tryParse(studentIdController.text);
                              if (studentId != null) {
                                controller.addStudentToClass(
                                    studentId, classId);
                                studentIdController.clear();
                              } else {
                                Get.snackbar(
                                    'خطأ', 'يرجى إدخال معرف طالب صحيح');
                              }
                            },
                            child: const Text('إضافة طالب'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _showStudentDetails(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الطالب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم الأول: ${student['student_firstname']}'),
            Text('الاسم الأخير: ${student['student_lastname']}'),
            Text('معرف الولي: ${student['student_gaurdianid'] ?? 'غير محدد'}'),
            Text('رقم الهاتف: ${student['student_phonenumber'] ?? 'غير محدد'}'),
            Text('معرف الطالب: ${student['student_id']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int studentId) {
    final controller = Get.find<ClassController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا الطالب من الصف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteStudentFromClass(studentId, classId);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
