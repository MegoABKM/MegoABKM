import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:schoolmanagement/view/widget/student%20management/studentdashbaord/marker.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الحضور والغياب',
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 10),
      
        Text(
          'عدد أيام الغياب: ${controller.absenceCount}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.red, 
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          eventLoader: (day) {
            if (controller.absenceDates.any((d) => isSameDay(d, day))) {
              return ['Absent'];
            } else if (controller.presentDates.any((d) => isSameDay(d, day))) {
              return ['Present'];
            }
            return [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                if (events.contains('Absent')) {
                  return const Marker(color: Colors.red);
                } else if (events.contains('Present')) {
                  return const Marker(color: Colors.green);
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
