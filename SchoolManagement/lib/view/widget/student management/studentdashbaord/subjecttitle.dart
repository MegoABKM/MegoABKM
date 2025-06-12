// Subject Tile Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/subjectfilecontroller/subjectfilecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectTile extends StatelessWidget {
  final Map<String, dynamic> subject;

  const SubjectTile({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubjectFilesController(),
        tag: subject['subject_id'].toString());
    controller.onSubjectSelected(subject['subject_id'].toString());

    return ExpansionTile(
      title: Text(subject['subject_name'] ?? 'مادة غير محددة'),
      children: [
        GetBuilder<SubjectFilesController>(
          tag: subject['subject_id'].toString(),
          builder: (fileController) {
            if (fileController.files.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('لا توجد ملفات لهذه المادة'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fileController.files.length,
              itemBuilder: (context, index) {
                final file = fileController.files[index];
                return ListTile(
                  title: Text(file['file_name'] ?? 'ملف غير محدد'),
                  subtitle:
                      Text('نوع الملف: ${file['file_type'] ?? 'غير معروف'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final url = fileController
                          .getDownloadUrl(file['file_path'] ?? '');
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        Get.snackbar('خطأ', 'لا يمكن تحميل الملف');
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
