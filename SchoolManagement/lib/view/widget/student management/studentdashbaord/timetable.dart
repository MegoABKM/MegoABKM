import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';

class TimetableWidget extends StatelessWidget {
  const TimetableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();
    final theme = Theme.of(context);
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    final timeSlots = controller.timetable
        .map((e) => e['time_slot'] as String)
        .toSet()
        .toList()
      ..sort(_compareTimeSlots); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجدول الزمني',
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 10),
        if (controller.timetable.isEmpty)
          const Text('لا يوجد جدول زمني متاح')
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('اليوم')),
                ...timeSlots.map((slot) => DataColumn(label: Text(slot))),
              ],
              rows: days.map((day) {
                return DataRow(
                  cells: [
                    DataCell(Text(_translateDay(day))),
                    ...timeSlots.map((slot) {
                      final entry = controller.timetable.firstWhere(
                        (e) => e['day'] == day && e['time_slot'] == slot,
                        orElse: () => {},
                      );
                      return DataCell(
                        Text(
                          entry.isNotEmpty
                              ? (entry['subjects']?['subject_name'] ??
                                  'غير محدد')
                              : '-',
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
      ],
    );
  }

  int _compareTimeSlots(String a, String b) {
    final startA = a.split('-')[0]; 
    final startB = b.split('-')[0]; 

    final hourA = int.parse(startA.split(':')[0]);
    final minuteA = int.parse(startA.split(':')[1]);
    final hourB = int.parse(startB.split(':')[0]);
    final minuteB = int.parse(startB.split(':')[1]);

    if (hourA != hourB) return hourA - hourB;
    return minuteA - minuteB;
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
