import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/deletestudent.dart';

class DeleteStudentScreen extends StatelessWidget {
  final DeleteStudentController controller = Get.put(DeleteStudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف طالب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن الطالب (معرف، الاسم الأول، أو الأخير)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: controller.searchStudents,
                ),
              ),
              onSubmitted: (value) => controller.searchStudents(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchController.text.isNotEmpty &&
                    controller.searchResults.isEmpty) {
                  return const Center(child: Text('لا يوجد طلاب مطابقون'));
                }
                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final student = controller.searchResults[index];
                    return InkWell(
                      onTap: () {
                        _showDeleteConfirmationDialog(
                            context, student['student_id']);
                      },
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${student['student_id']} - ${student['student_firstname']} ${student['student_lastname']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      'المرحلة: ${student['student_stage'] ?? 'غير محدد'}'),
                                  Text(
                                      'تاريخ الميلاد: ${student['student_born'] ?? 'غير محدد'}'),
                                ],
                              ),
                              const Icon(Icons.delete, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
            'هل أنت متأكد من حذف هذا الطالب؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.deleteStudent(studentId);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
