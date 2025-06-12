import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/absentcalender.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/classinfo.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/message.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/notification.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/studentdrawer.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/subjectfiles.dart'; // Verify this path
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/teacherbutton.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/timetable.dart';
import 'package:schoolmanagement/view/widget/student management/studentdashbaord/welcomewidget.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentDashboardController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'لوحة تحكم الطالب',
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.appBarTheme.foregroundColor),
        ),
        centerTitle: true,
      ),
      drawer: const StudentDrawer(),
      body: GetBuilder<StudentDashboardController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: AppThemes.defaultPadding,
            child: ListView(
              children: const [
                WelcomeWidget(),
                SizedBox(height: 20),
                NotificationsWidget(),
                SizedBox(height: 20),
                MessagesWidget(),
                SizedBox(height: 20),
                ClassInfoWidget(),
                SizedBox(height: 20),
                TimetableWidget(),
                SizedBox(height: 20),
                AttendanceWidget(),
                SizedBox(height: 20),
                SubjectFilesWidget(),
                SizedBox(height: 20),
                TeachersButtonWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
