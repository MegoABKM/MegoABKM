// lib/screens/absent_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/absent/absent_controller.dart';

class AbsentPage extends StatelessWidget {
  const AbsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AbsentController controller = Get.put(AbsentController());

    return GetBuilder<AbsentController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('تسجيل الغياب')),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        hint: const Text('اختر المرحلة'),
                        value: controller.selectedStage,
                        items: List.generate(12, (index) => index + 1)
                            .map((stage) => DropdownMenuItem<int>(
                                  value: stage,
                                  child: Text('المرحلة $stage'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedStage = value;
                          controller.selectedClassId = null;
                          controller.selectedDate = null;
                          controller.students.clear();
                          controller.absentStudents.clear();
                          controller.update();
                        },
                      ),
                      const SizedBox(height: 10),
                      if (controller.selectedStage != null)
                        DropdownButton<int>(
                          hint: const Text('اختر الصف'),
                          value: controller.selectedClassId,
                          items: controller
                              .getClassesForStage(controller.selectedStage!)
                              .map((classItem) => DropdownMenuItem<int>(
                                    value: classItem['class_id'],
                                    child: Text(classItem['class_name']),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            controller.selectedClassId = value;
                            controller.selectedDate = null;
                            controller.students.clear();
                            controller.absentStudents.clear();
                            controller.update();
                          },
                        ),
                      const SizedBox(height: 10),
                      if (controller.selectedClassId != null)
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              controller.selectedDate = pickedDate;
                              controller.fetchStudentsAndAbsences(
                                  controller.selectedClassId!);
                            }
                          },
                          child: Text(
                            controller.selectedDate == null
                                ? 'اختر تاريخ الغياب'
                                : 'التاريخ: ${controller.selectedDate!.toString().split(' ')[0]}',
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (controller.students.isNotEmpty &&
                          controller.selectedDate != null)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('رقم الطالب')),
                                DataColumn(label: Text('اسم الطالب')),
                                DataColumn(label: Text('غائب')),
                              ],
                              rows: controller.students.map((student) {
                                final studentId = student['student_id'];
                                final isAbsent = controller.absentStudents
                                    .firstWhere(
                                        (s) => s['student_id'] == studentId,
                                        orElse: () => {
                                              'is_absent': false
                                            })['is_absent'] as bool;
                                return DataRow(cells: [
                                  DataCell(Text(studentId.toString())),
                                  DataCell(Text(
                                      '${student['student_firstname']} ${student['student_lastname']}')),
                                  DataCell(
                                    Checkbox(
                                      value: isAbsent,
                                      onChanged: (value) {
                                        controller.toggleAbsence(
                                            studentId, value ?? false);
                                      },
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      if (controller.students.isNotEmpty &&
                          controller.selectedDate != null)
                        const SizedBox(height: 20),
                      if (controller.selectedClassId != null &&
                          controller.selectedDate != null &&
                          controller.students.isNotEmpty)
                        ElevatedButton(
                          onPressed: () => controller
                              .submitAbsences(controller.selectedClassId!),
                          child: const Text('تحديث الغياب'),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
