import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/teachermanagement/addteacher.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class AddTeacherScreen extends StatelessWidget {
  final AddTeacherController controller = Get.put(AddTeacherController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة معلم'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  controller.firstNameController, 'الاسم الأول', "username"),
              _buildTextField(
                  controller.lastNameController, 'اسم العائلة', null),
              _buildTextField(
                  controller.emailController, 'البريد الإلكتروني', "email",
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(
                  controller.passwordController, 'كلمة المرور', "password",
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(
                  controller.phoneNumberController, 'رقم الهاتف', "phone",
                  keyboardType: TextInputType.phone),
              _buildTextField(controller.bornController, 'تاريخ الميلاد', null),
              const SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.addTeacher();
                          }
                        },
                        child: const Text('إضافة معلم'),
                      ),
                    )),
            ],
          ),
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
