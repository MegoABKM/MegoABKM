import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/sendmessage/sendmessage_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';

class SendMessageScreen extends StatelessWidget {
  const SendMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SendMessageController());
    final theme = Theme.of(context);
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text(
          'إرسال رسالة للطلاب',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppThemes.defaultPadding,
        child: GetBuilder<SendMessageController>(
          builder: (controller) {
            if (controller.isLoadingStudents) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.students.isEmpty) {
              return const Center(
                  child: Text('لا يوجد طلاب لإرسال الرسائل إليهم'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: controller.selectAllStudents,
                      onChanged: (value) {
                        controller.toggleSelectAll(value ?? false);
                      },
                    ),
                    const Text('تحديد الكل'),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.students.length,
                    itemBuilder: (context, index) {
                      final student = controller.students[index];
                      return CheckboxListTile(
                        title: Text(
                          '${student['student_firstname']} ${student['student_lastname']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        value: controller.selectedStudents
                            .contains(student['student_id']),
                        onChanged: (value) {
                          controller.toggleStudentSelection(
                              student['student_id'], value ?? false);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'اكتب رسالتك هنا',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: controller.isSendingMessage
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (controller.selectedStudents.isEmpty) {
                              Get.snackbar(
                                  'خطأ', 'يرجى تحديد طالب واحد على الأقل');
                              return;
                            }
                            if (messageController.text.trim().isEmpty) {
                              Get.snackbar('خطأ', 'يرجى كتابة رسالة');
                              return;
                            }
                            controller.sendMessageToStudents(
                                messageController.text.trim());
                          },
                          child: const Text('إرسال الرسالة'),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
