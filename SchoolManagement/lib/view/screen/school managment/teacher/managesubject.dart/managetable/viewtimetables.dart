// lib/screens/view_timetable_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/subjecmanagement/tablemanagement/viewtimetable_controller.dart';
import 'package:schoolmanagement/view/screen/school%20managment/teacher/managesubject.dart/managetable/updatetimetable.dart';

class ViewTimetablePage extends GetView<ViewTimetableController> {
  const ViewTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ViewTimetableController());

    return Scaffold(
      appBar: AppBar(title: const Text('عرض جدول الحصص')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                return DropdownButton<int>(
                  hint: const Text('اختر المرحلة'),
                  value: controller.selectedStageId.value,
                  items: List.generate(12, (index) => index + 1).map((stage) {
                    return DropdownMenuItem<int>(
                      value: stage,
                      child: Text('المرحلة $stage'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) controller.setStage(value);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final filteredClasses = controller.selectedStageId.value == null
                    ? <Map<String, dynamic>>[]
                    : controller.classes
                        .where((c) =>
                            c['stage'] == controller.selectedStageId.value)
                        .toList();
                return DropdownButton<int>(
                  hint: const Text('اختر الصف'),
                  value: controller.selectedClassId.value,
                  items: filteredClasses.map((classItem) {
                    return DropdownMenuItem<int>(
                      value: classItem['class_id'],
                      child: Text(classItem['class_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) controller.setClass(value);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedClassId.value == null) {
                    Get.snackbar('خطأ', 'يرجى اختيار الصف أولاً');
                    return;
                  }
                  Get.to(() => EditTimetablePage(
                      classId: controller.selectedClassId.value!));
                },
                child: const Text('تعديل الجدول'),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                          final subject =
                              controller.getSubjectForSlot(timeSlot, day);
                          return DataCell(Text(subject));
                        }),
                      ],
                    );
                  }).toList(),
                  columnSpacing: 20,
                  dataRowHeight: 60,
                  headingRowHeight: 60,
                  border: TableBorder.all(color: Colors.grey.shade300),
                ),
              );
            }),
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
