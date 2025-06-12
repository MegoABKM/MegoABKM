import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/updatestudentdetails.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class UpdateStudentDetailsScreen extends StatelessWidget {
  final UpdateStudentDetailsController controller =
      Get.put(UpdateStudentDetailsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل بيانات الطالب'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Info Section
                const Text(
                  'تفاصيل الطالب',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    controller.firstNameController, 'الاسم الأول', "username"),
                _buildTextField(
                    controller.lastNameController, 'اسم العائلة', null),
                _buildTextField(controller.ageController, 'العمر', null,
                    keyboardType: TextInputType.number),
                _buildTextField(controller.stageController, 'المرحلة', null),
                _buildTextField(
                    controller.emailController, 'البريد الإلكتروني', "email",
                    keyboardType: TextInputType.emailAddress),
                _buildTextField(
                    controller.phoneNumberController, 'رقم الهاتف', "phone",
                    keyboardType: TextInputType.phone),
                _buildTextField(
                    controller.bornController, 'تاريخ الميلاد', null),

                // Guardian Info Section
                const SizedBox(height: 30),
                const Text(
                  'تفاصيل ولي الأمر',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(controller.guardianFullNameController,
                    'الاسم الكامل', null),
                _buildTextField(controller.guardianPhoneNumberController,
                    'رقم الهاتف', "phone",
                    keyboardType: TextInputType.phone),
                _buildTextField(
                    controller.guardianBornController, 'تاريخ الميلاد', null),
                _buildTextField(
                    controller.guardianCountryController, 'الدولة', null),
                _buildTextField(
                    controller.guardianCityController, 'المدينة', null),
                _buildTextField(
                    controller.guardianNeighborhoodController, 'الحي', null),
                _buildTextField(controller.guardianStreetNameController,
                    'اسم الشارع', null),
                _buildTextField(controller.guardianBuildNumberController,
                    'رقم المبنى', null,
                    keyboardType: TextInputType.number),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.updateStudent();
                      }
                    },
                    child: const Text(
                      'حفظ التغييرات',
                      style:
                          TextStyle(fontFamily: 'NotoKufiArabic', fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
        validator: (value) {
          return validInput(value ?? '', 2, 50, type);
        },
      ),
    );
  }
}
