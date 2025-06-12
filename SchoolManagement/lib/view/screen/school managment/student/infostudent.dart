import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/infostudent.dart';

class StudentInfoScreen extends StatelessWidget {
  final StudentInfoController controller = Get.put(StudentInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات الطالب'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final student = controller.student.value;
        final guardian = controller.guardian.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تفاصيل الطالب',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                  'الاسم الأول', student['student_firstname'] ?? 'غير محدد'),
              _buildInfoRow(
                  'اسم العائلة', student['student_lastname'] ?? 'غير محدد'),
              _buildInfoRow(
                  'العمر', student['student_age']?.toString() ?? 'غير محدد'),
              _buildInfoRow('المرحلة', student['student_stage'] ?? 'غير محدد'),
              _buildInfoRow(
                  'البريد الإلكتروني', student['student_email'] ?? 'غير محدد'),
              _buildInfoRow(
                  'رقم الهاتف', student['student_phonenumber'] ?? 'غير محدد'),
              _buildInfoRow(
                  'تاريخ الميلاد', student['student_born'] ?? 'غير محدد'),

              const SizedBox(height: 30),
              const Text(
                'تفاصيل ولي الأمر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                  'الاسم الكامل', guardian['gaurdian_fullname'] ?? 'غير محدد'),
              _buildInfoRow(
                  'رقم الهاتف', guardian['gaurdian_phonenumber'] ?? 'غير محدد'),
              _buildInfoRow(
                  'تاريخ الميلاد', guardian['gaurdian_born'] ?? 'غير محدد'),
              _buildInfoRow(
                  'الدولة', guardian['gaurdian_country'] ?? 'غير محدد'),
              _buildInfoRow('المدينة', guardian['gaurdian_city'] ?? 'غير محدد'),
              _buildInfoRow(
                  'الحي', guardian['gaurdian_neighberhood'] ?? 'غير محدد'),
              _buildInfoRow(
                  'اسم الشارع', guardian['gaurdian_streetname'] ?? 'غير محدد'),
              _buildInfoRow(
                  'رقم المبنى', guardian['gaurdian_buildnumber'] ?? 'غير محدد'),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
