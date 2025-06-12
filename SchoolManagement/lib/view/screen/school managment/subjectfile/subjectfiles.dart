import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/subjectfilecontroller/subjectfilecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectFilesScreen extends StatelessWidget {
  const SubjectFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectFilesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملفات المواد'),
        centerTitle: true,
      ),
      body: GetBuilder<SubjectFilesController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  hint: const Text('اختر مادة'),
                  value: controller.selectedSubjectId,
                  onChanged: controller.onSubjectSelected,
                  items: controller.subjects.map((subject) {
                    final id = subject['subject_id']?.toString() ?? '0';
                    final name =
                        subject['subject_name']?.toString() ?? 'Unnamed';
                    return DropdownMenuItem(
                      value: id,
                      child: Text(name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (controller.selectedSubjectId != null) ...[
                  ElevatedButton(
                    onPressed: controller.isUploading.value
                        ? null
                        : () => controller
                            .uploadFile(controller.selectedSubjectId!),
                    child: const Text('رفع ملف'),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => controller.isUploading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            controller.uploadStatus.value,
                            style: TextStyle(
                              color:
                                  controller.uploadStatus.value.contains('فشل')
                                      ? Colors.red
                                      : controller.uploadStatus.value
                                              .contains('نجاح')
                                          ? Colors.green
                                          : Colors.black,
                            ),
                          ),
                  ),
                ],
                const SizedBox(height: 20),
                Expanded(
                  child: controller.files.isEmpty
                      ? const Center(child: Text('لا توجد ملفات بعد'))
                      : ListView.builder(
                          itemCount: controller.files.length,
                          itemBuilder: (context, index) {
                            final file = controller.files[index];
                            return ListTile(
                              title: Text(file['file_name'] ?? 'Unnamed File'),
                              subtitle: Text(
                                  'نوع الملف: ${file['file_type'] ?? 'Unknown'}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () async {
                                      final url = controller.getDownloadUrl(
                                          file['file_path'] ?? '');
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        Get.snackbar(
                                            'خطأ', 'لا يمكن تحميل الملف');
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => controller.deleteFile(
                                      file['id']?.toString() ?? '0',
                                      file['file_path'] ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
