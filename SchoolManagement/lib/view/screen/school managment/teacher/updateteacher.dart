import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/updateteacher.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class UpdateTeacherScreen extends StatelessWidget {
  final UpdateTeacherController controller = Get.put(UpdateTeacherController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديث معلم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن المعلم (الاسم الأول أو الأخير)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: controller.searchTeachers,
                ),
              ),
              onSubmitted: (value) => controller.searchTeachers(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchController.text.isNotEmpty &&
                    controller.searchResults.isEmpty) {
                  return const Center(child: Text('لا يوجد معلمون مطابقون'));
                }
                if (controller.selectedTeacher.value == null) {
                  return ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final teacher = controller.searchResults[index];
                      return InkWell(
                        onTap: () => controller.loadTeacherDetails(teacher),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                '${teacher['teacher_firstname']} ${teacher['teacher_lastname']}'),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTextField(controller.firstNameController,
                            'الاسم الأول', "username"),
                        _buildTextField(
                            controller.lastNameController, 'اسم العائلة', null),
                        _buildTextField(controller.emailController,
                            'البريد الإلكتروني', "email",
                            keyboardType: TextInputType.emailAddress),
                        _buildTextField(controller.phoneNumberController,
                            'رقم الهاتف', "phone",
                            keyboardType: TextInputType.phone),
                        _buildTextField(
                            controller.bornController, 'تاريخ الميلاد', null),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.updateTeacher();
                              }
                            },
                            child: const Text('حفظ التغييرات'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String? type,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => validInput(value ?? '', 2, 50, type),
      ),
    );
  }
}
