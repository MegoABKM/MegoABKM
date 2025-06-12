// lib/screens/gaurdian_search_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:schoolmanagement/controller/schoolmanagment/gaurdian/gaurdiansearch.dart';
import 'package:url_launcher/url_launcher.dart';

class GaurdianSearchPage extends StatelessWidget {
  const GaurdianSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GaurdianController());

    return Scaffold(
      appBar: AppBar(title: const Text('البحث عن ولي الأمر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<GaurdianController>(
          builder: (controller) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'ابحث بالاسم أو رقم الطالب',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.searchQuery = value;
                    controller.searchStudents();
                  },
                ),
                const SizedBox(height: 20),
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!controller.isLoading && controller.students.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.students.length,
                      itemBuilder: (context, index) {
                        final student = controller.students[index];
                        return ListTile(
                          title: Text(
                              '${student['student_firstname']} ${student['student_lastname']}'),
                          subtitle:
                              Text('رقم الطالب: ${student['student_id']}'),
                          onTap: () {
                            controller.fetchGaurdianInfo(student['student_id']);
                          },
                        );
                      },
                    ),
                  ),
                if (!controller.isLoading &&
                    controller.students.isEmpty &&
                    controller.searchQuery.isNotEmpty)
                  const Text('لم يتم العثور على طلاب'),
                if (controller.gaurdianInfo != null)
                  Card(
                    margin: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'اسم ولي الأمر: ${controller.gaurdianInfo!['gaurdian_fullname']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                              'رقم الهاتف: ${controller.gaurdianInfo!['gaurdian_phonenumber']}'),
                          Text(
                              'تاريخ الميلاد: ${controller.gaurdianInfo!['gaurdian_born'] ?? 'غير متوفر'}'),
                          Text(
                              'الدولة: ${controller.gaurdianInfo!['gaurdian_country'] ?? 'غير متوفر'}'),
                          Text(
                              'المدينة: ${controller.gaurdianInfo!['gaurdian_city'] ?? 'غير متوفر'}'),
                          Text(
                              'الحي: ${controller.gaurdianInfo!['gaurdian_neighberhood'] ?? 'غير متوفر'}'),
                          Text(
                              'اسم الشارع: ${controller.gaurdianInfo!['gaurdian_streetname'] ?? 'غير متوفر'}'),
                          Text(
                              'رقم المبنى: ${controller.gaurdianInfo!['gaurdian_buildnumber'] ?? 'غير متوفر'}'),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.phone),
                            label: const Text('اتصال'),
                            onPressed: () async {
                              final phone = controller
                                  .gaurdianInfo!['gaurdian_phonenumber'];
                              await _launchPhoneCall(phone);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        Get.snackbar('خطأ', 'يرجى منح إذن الاتصال لاستخدام هذه الميزة');
        return;
      }
    }

    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!cleanedNumber.startsWith('+')) {
      cleanedNumber = cleanedNumber;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('خطأ',
          'لا يمكن إجراء المكالمة. تحقق من رقم الهاتف أو إعدادات الجهاز');
    }
  }
}
