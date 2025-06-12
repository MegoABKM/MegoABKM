import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/controller/auth/signupschool_controller.dart';
import 'package:schoolmanagement/core/functions/validinput.dart';

class SchoolSignup extends StatelessWidget {
  SchoolSignup({super.key});

  final SignupschoolController controller = Get.put(SignupschoolController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_downward,
                    color: theme.colorScheme.onBackground,
                    size: 30,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'مرشد',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildSectionTitle("بيانات المدرسة", theme),
                        _buildTextField("البريد الإلكتروني للمدرسة",
                            controller.schoolEmailController, theme,
                            type: "email"),
                        _buildTextField("كلمة المرور",
                            controller.schoolPasswordController, theme,
                            isPassword: true),
                        _buildTextField("اسم المدرسة",
                            controller.schoolNameController, theme),
                        _buildTextField("مرحلة التعليم",
                            controller.schoolLearnStageController, theme),
                        _buildTextField("نوع الدراسة (أدبي - علمي - شريعة)",
                            controller.schoolLearnTypeController, theme),
                        _buildSectionTitle("موقع المدرسة", theme),
                        _buildTextField("الدولة",
                            controller.locationCountryController, theme),
                        _buildTextField("المدينة",
                            controller.locationCityController, theme),
                        _buildTextField("الولاية",
                            controller.locationStateController, theme),
                        _buildTextField("اسم الحي",
                            controller.locationNeighborhoodController, theme),
                        _buildTextField("اسم الشارع",
                            controller.locationStreetController, theme),
                        _buildTextField("رقم المبنى",
                            controller.locationBuildingNumberController, theme),
                        _buildSectionTitle("بيانات المدير", theme),
                        _buildTextField("الاسم الأول",
                            controller.managerFirstNameController, theme),
                        _buildTextField("الاسم الأخير",
                            controller.managerLastNameController, theme),
                        _buildTextField("البريد الإلكتروني الخاص بالمدير",
                            controller.managerEmailController, theme,
                            type: "email"),
                        _buildTextField("رقم الهاتف",
                            controller.managerPhoneNumberController, theme,
                            type: "phone"),
                        const SizedBox(height: 20),
                        GetBuilder<SignupschoolController>(
                          builder: (controller) => controller.isloading == true
                              ? CircularProgressIndicator(
                                  color: theme.colorScheme.secondary,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      controller.insertSchoolData();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        theme.colorScheme.onTertiary,
                                    backgroundColor: theme.colorScheme.tertiary,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'تسجيل',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            controller.insertSchoolData();
                          },
                          child: Text(
                            'لديك حساب بالفعل؟ سجل الدخول',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'بالاستمرار، أنت توافق على شروط الخدمة وسياسة الخصوصية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, ThemeData theme,
      {bool isPassword = false, String? type}) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: (val) => validInput(val!, 3, 50, type),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          style: TextStyle(
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
