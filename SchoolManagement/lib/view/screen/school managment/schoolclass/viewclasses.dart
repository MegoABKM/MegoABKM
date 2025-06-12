// lib/screens/view_classes_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/classmanagement/crudclass_controller.dart';
import 'package:schoolmanagement/view/screen/school%20managment/schoolclass/addviewstudenttoclass.dart';
import 'package:schoolmanagement/view/screen/school%20managment/schoolclass/createclass.dart';

class ViewClassesPage extends StatelessWidget {
  const ViewClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.put(ClassController());

    return GetBuilder<ClassController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('عرض الفصول'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Get.to(() => const CreateClassPage()),
              ),
            ],
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.classes.isEmpty
                  ? const Center(child: Text('لا توجد فصول'))
                  : ListView.builder(
                      itemCount: controller.classes.length,
                      itemBuilder: (context, index) {
                        final classItem = controller.classes[index];
                        final classNameController = TextEditingController(
                            text: classItem['class_name'] ?? '');
                        final placeController = TextEditingController(
                            text: classItem['place'] ?? '');
                        return ExpansionTile(
                          title: Text(
                              '${classItem['class_name']} (المرحلة ${classItem['stage']})'),
                          subtitle: FutureBuilder<int>(
                            future: controller
                                .getStudentCount(classItem['class_id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('جارٍ تحميل عدد الطلاب...');
                              }
                              return Text(
                                  'المكان: ${classItem['place'] ?? 'غير محدد'} | الطلاب: ${snapshot.data ?? 0}');
                            },
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: classNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'اسم الصف'),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: placeController,
                                    decoration: const InputDecoration(
                                        labelText: 'المكان'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      final className =
                                          classNameController.text.isEmpty
                                              ? classItem['class_name']
                                              : classNameController.text;
                                      final place = placeController.text.isEmpty
                                          ? classItem['place']
                                          : placeController.text;
                                      controller.updateClass(
                                          classItem['class_id'],
                                          className,
                                          place);
                                    },
                                    child: const Text('تحديث'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.fetchStudentsInClass(
                                          classItem['class_id']);
                                      Get.to(() => ClassStudentsPage(
                                          classId: classItem['class_id']));
                                    },
                                    child: const Text('عرض الطلاب'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
        );
      },
    );
  }
}
