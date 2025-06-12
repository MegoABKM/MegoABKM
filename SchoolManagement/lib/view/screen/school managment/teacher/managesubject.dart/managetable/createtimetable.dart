// lib/screens/timetable_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/tablemanagement/createtimetable.dart';

class CreateTimetablePage extends GetView<CreateTimetableController> {
  const CreateTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateTimetableController());

    return Scaffold(
      appBar: AppBar(title: const Text('جدول الحصص')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (controller.isLoading.value && controller.subjects.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
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
                      onPressed: controller.addTimetableEntry,
                      child: const Text('إضافة إلى الجدول'),
                    ),
                  ],
                );
              }),
            ),
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      const DataColumn(label: Text('اليوم')),
                      ...controller.timeSlots
                          .map((timeSlot) => DataColumn(label: Text(timeSlot))),
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
                                    final index = controller.timetableEntries
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
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: const Text('تعديل الجدول'),
                children: [
                  for (var day in controller.days)
                    for (var timeSlot in controller.timeSlots)
                      Obx(() {
                        final currentSubject =
                            controller.getSubjectForSlot(timeSlot, day);
                        return ListTile(
                          title: Text('${_translateDay(day)} $timeSlot'),
                          trailing: DropdownButton<String>(
                            value:
                                currentSubject.isEmpty ? null : currentSubject,
                            hint: const Text('اختر المادة'),
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
                                final index = controller.timetableEntries
                                    .indexWhere((e) =>
                                        e.timeSlot == timeSlot && e.day == day);
                                if (index != -1) {
                                  controller.timetableEntries.removeAt(index);
                                  controller.timetableEntries.refresh();
                                }
                              }
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Obx(() {
                return DropdownButton<int>(
                  hint: const Text('اختر الصف'),
                  value: controller.selectedClassId.value,
                  items: controller.classes.map((classItem) {
                    return DropdownMenuItem<int>(
                      value: classItem['class_id'],
                      child: Text(
                          '${classItem['class_name']} (المرحلة ${classItem['stage']})'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      controller.selectedClassId.value = value,
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: controller.uploadToDatabase,
                child: const Text('رفع إلى قاعدة البيانات'),
              ),
            ),
          ],
        ),
      ),
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
