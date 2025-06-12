import 'package:flutter/material.dart';
import 'package:schoolmanagement/main.dart'; // For myServices.sharedPreferences

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String name =
        myServices.sharedPreferences.getString("student_firstname") ??
            'غير محدد';
    final String id =
        myServices.sharedPreferences.getString("student_id") ?? 'غير محدد';
    final String email =
        myServices.sharedPreferences.getString("student_email") ?? 'غير محدد';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحبًا، $name!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.badge, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'معرف الطالب: $id',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.email, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'البريد الإلكتروني: $email',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
