import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/updatestudent.dart';
import 'package:schoolmanagement/view/screen/school%20managment/student/updatestudentdetails.dart';

class UpdateStudentScreen extends StatelessWidget {
  final UpdateStudentController controller = Get.put(UpdateStudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن طالب للتعديل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن الطالب (الاسم الأول أو الأخير)',
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
                        Get.to(() => UpdateStudentDetailsScreen(),
                            arguments: {'student': student});
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
                                    '${student['student_firstname']} ${student['student_lastname']}',
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
                              const Icon(Icons.arrow_forward_ios, size: 16),
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
}
