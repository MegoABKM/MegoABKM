import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/deleteteacher.dart';

class DeleteTeacherScreen extends StatelessWidget {
  final DeleteTeacherController controller = Get.put(DeleteTeacherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف معلم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن المعلم (الاسم الأول أو الأخير)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: controller.searchTeachers,
                ),
              ),
              onSubmitted: (value) => controller.searchTeachers(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchController.text.isNotEmpty &&
                    controller.searchResults.isEmpty) {
                  return const Center(child: Text('لا يوجد معلمون مطابقون'));
                }
                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final teacher = controller.searchResults[index];
                    return InkWell(
                      onTap: () => _showDeleteConfirmationDialog(
                          context, teacher['teacher_id']),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${teacher['teacher_firstname']} ${teacher['teacher_lastname']}'),
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

  void _showDeleteConfirmationDialog(BuildContext context, int teacherId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المعلم؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTeacher(teacherId);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
