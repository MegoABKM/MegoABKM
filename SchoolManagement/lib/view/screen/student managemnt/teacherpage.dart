import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';
import 'package:url_launcher/url_launcher.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المعلمون'),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppThemes.defaultPadding,
        child: ListView(
          children: [
            Text(
              'التواصل مع المعلمين',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.colorScheme.secondary),
            ),
            const SizedBox(height: 20),
            if (controller.subjects.isEmpty)
              const Text('لا توجد مواد متاحة')
            else
              ...controller.subjects
                  .map((subject) => TeacherTile(subject: subject)),
          ],
        ),
      ),
    );
  }
}

class TeacherTile extends StatelessWidget {
  final Map<String, dynamic> subject;

  const TeacherTile({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject['subject_name'] ?? 'مادة غير محددة',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'المعلم: ${subject['teacher']?['teacher_firstname'] ?? ''} ${subject['teacher']?['teacher_lastname'] ?? ''}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    final phone = subject['teacher']?['teacher_phonenumber'];
                    if (phone != null && phone.isNotEmpty) {
                      launch('tel:$phone');
                    } else {
                      Get.snackbar('خطأ', 'رقم الهاتف غير متاح');
                    }
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ChatScreen(
                          teacherId: subject['teacher']?['teacher_id'],
                          teacherName:
                              '${subject['teacher']?['teacher_firstname'] ?? ''} ${subject['teacher']?['teacher_lastname'] ?? ''}',
                        ));
                  },
                  child: const Text('إرسال رسالة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final int? teacherId;
  final String teacherName;

  const ChatScreen(
      {super.key, required this.teacherId, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('محادثة مع $teacherName'),
      ),
      body: const Center(
        child: Text('هنا سيتم عرض المحادثة مع المعلم (قيد التطوير)'),
      ),
    );
  }
}
