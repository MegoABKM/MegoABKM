import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/studentmanagment/studentdashboard_controller.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإشعارات',
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 10),
        GetBuilder<StudentDashboardController>(
          builder: (controller) {
            if (controller.notifications.isEmpty) {
              return const Text('لا توجد إشعارات');
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return ListTile(
                  title: Text(notification['message']),
                  subtitle:
                      Text(notification['created_at'].toString().split('T')[0]),
                  trailing: notification['is_read']
                      ? null
                      : const Icon(Icons.circle, color: Colors.red, size: 10),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
