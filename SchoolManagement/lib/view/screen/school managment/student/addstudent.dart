import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/schoolmanagment/studentmanagement/addstudent.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class AddStudentScreen extends StatelessWidget {
  final AddStudentController controller = Get.put(AddStudentController());
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طالب'),
      ),
      body: Form(
        key: _formKey, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معلومات الطالب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField(controller.studentFirstNameController,
                  'الاسم الأول', "username"),
              _buildTextField(
                  controller.studentLastNameController, 'اسم العائلة', null),
              _buildTextField(controller.studentAgeController, 'العمر', null,
                  keyboardType: TextInputType.number),
              _buildTextField(
                  controller.studentStageController, 'المرحلة', null),

              _buildTextField(controller.studentEmailController,
                  'البريد الإلكتروني', "email",
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(
                  controller.studentPasswordController, 'كلمة المرور', null,
                  obscureText: true),
              _buildTextField(controller.studentPhoneNumberController,
                  'رقم الهاتف', "phone",
                  keyboardType: TextInputType.phone),
              _buildTextField(
                  controller.studentBornController, 'تاريخ الميلاد', null),

              const SizedBox(height: 20),
              const Text(
                'معلومات ولي الأمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                  controller.guardianFullNameController, 'الاسم الكامل', null),
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
              _buildTextField(
                  controller.guardianStreetNameController, 'اسم الشارع', null),
              _buildTextField(
                  controller.guardianBuildNumberController, 'رقم المبنى', null,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 20),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Center the loading indicator
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller
                                  .addStudent(); // Call addStudent only if form is valid
                            } else {
                              print(
                                  'Form validation failed'); // Debug print for validation failure
                            }
                          },
                          child: const Text(
                            'إضافة طالب',
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
              }),
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
        validator: (value) {
          return validInput(
              value ?? "", 2, 50, type);
        },
      ),
    );
  }
}
