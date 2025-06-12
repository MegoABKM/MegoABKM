import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectFilesWidget extends StatelessWidget {
  const SubjectFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();

    Map<String, List<Map<String, dynamic>>> groupedFiles = {};
    for (var file in controller.subjectFiles) {
      final subjectId = file['subject_id'].toString();
      final subject = controller.subjects.firstWhere(
          (s) => s['subject_id'].toString() == subjectId,
          orElse: () => {});
      final subjectName =
          subject.isNotEmpty ? subject['subject_name'] : 'غير مصنف';

      if (!groupedFiles.containsKey(subjectName)) {
        groupedFiles[subjectName] = [];
      }
      groupedFiles[subjectName]!.add(file);
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملفات المواد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            controller.subjectFiles.isEmpty
                ? const Center(child: Text('لا توجد ملفات متاحة'))
                : Column(
                    children: groupedFiles.entries.map((entry) {
                      final subjectName = entry.key;
                      final files = entry.value;

                      return ExpansionTile(
                        title: Text(
                          subjectName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: files.map((file) {
                          return ListTile(
                            title: Text(file['file_name'] ?? 'ملف بدون اسم'),
                            subtitle: Text(
                                'نوع الملف: ${file['file_type'] ?? 'غير معروف'}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () async {
                                final url = controller
                                    .getDownloadUrl(file['file_path'] ?? '');
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  Get.snackbar('خطأ', 'لا يمكن تحميل الملف');
                                }
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
