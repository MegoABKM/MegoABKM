import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<StudentDashboardController>();

    return Card(
      child: Padding(
        padding: AppThemes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                'الرسائل',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              children: [
                controller.messages.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('لا توجد رسائل جديدة'),
                      )
                    : Column(
                        children: controller.messages.map((message) {
                          return ListTile(
                            title: Text(
                              message['content'] ?? 'رسالة جديدة',
                              style: theme.textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              'تاريخ: ${message['sent_at']?.split('T')[0] ?? ''}',
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: message['is_read']
                                ? const Icon(Icons.check, color: Colors.green)
                                : const Icon(Icons.markunread,
                                    color: Colors.red),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
