// lib/screens/edit_timetable_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/tablemanagement/updatetimetable_controller.dart';

class EditTimetablePage extends StatelessWidget {
  final int? classId;

  const EditTimetablePage({super.key, this.classId});

  @override
  Widget build(BuildContext context) {
    // Register the controller before building the widget
    final controller = Get.put(EditTimetableController(classId: classId),
        tag: classId?.toString() ?? 'default');

    return GetBuilder<EditTimetableController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('تعديل الجدول')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButton<int>(
                          hint: const Text('اختر المادة'),
                          value: controller.selectedSubjectId.value,
                          items: controller.subjects.map((subject) {
                            return DropdownMenuItem<int>(
                              value: subject['subject_id'],
                              child: Text(subject['subject_name']),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              controller.selectedSubjectId.value = value,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: const Text('اختر اليوم'),
                          value: controller.selectedDay.value,
                          items: controller.days.map((day) {
                            return DropdownMenuItem<String>(
                              value: day,
                              child: Text(_translateDay(day)),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              controller.selectedDay.value = value,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: const Text('اختر الوقت'),
                          value: controller.selectedTimeSlot.value,
                          items: controller.timeSlots.map((slot) {
                            return DropdownMenuItem<String>(
                              value: slot,
                              child: Text(slot),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              controller.selectedTimeSlot.value = value,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: controller.addOrUpdateEntry,
                          child: const Text('إضافة/تحديث في الجدول'),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          const DataColumn(label: Text('اليوم')),
                          ...controller.timeSlots.map(
                              (timeSlot) => DataColumn(label: Text(timeSlot))),
                        ],
                        rows: controller.days.map((day) {
                          return DataRow(
                            cells: [
                              DataCell(Text(_translateDay(day))),
                              ...controller.timeSlots.map((timeSlot) {
                                final currentSubject =
                                    controller.getSubjectForSlot(timeSlot, day);
                                return DataCell(
                                  DropdownButton<String>(
                                    value: currentSubject.isEmpty
                                        ? null
                                        : currentSubject,
                                    hint: const Text(''),
                                    isDense: true,
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('لا شيء'),
                                      ),
                                      ...controller.subjects.map((subject) {
                                        return DropdownMenuItem<String>(
                                          value: subject['subject_name'],
                                          child: Text(subject['subject_name']),
                                        );
                                      }),
                                    ],
                                    onChanged: (value) {
                                      if (value != null && value != 'لا شيء') {
                                        controller.updateOrAddEntry(
                                            value, timeSlot, day);
                                      } else {
                                        final index = controller
                                            .timetableEntries
                                            .indexWhere((e) =>
                                                e.timeSlot == timeSlot &&
                                                e.day == day);
                                        if (index != -1) {
                                          controller.timetableEntries
                                              .removeAt(index);
                                          controller.timetableEntries.refresh();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                        columnSpacing: 20,
                        dataRowHeight: 60,
                        headingRowHeight: 60,
                        border: TableBorder.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: controller.updateTimetableInDatabase,
                      child: const Text('تحديث الجدول في قاعدة البيانات'),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String _translateDay(String day) {
    const dayTranslations = {
      'Sunday': 'الأحد',
      'Monday': 'الإثنين',
      'Tuesday': 'الثلاثاء',
      'Wednesday': 'الأربعاء',
      'Thursday': 'الخميس',
      'Friday': 'الجمعة',
      'Saturday': 'السبت',
    };
    return dayTranslations[day] ?? day;
  }
}
