import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/core/constant/routes.dart';

class LoginteacherController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;

  Future<void> login() async {
    print("=================Siginging teacher");
    if (formKey.currentState?.validate() ?? false) {
      isLoading = true;
      update();

      try {
        final response = await supabase
            .from('teachers')
            .select() //read
            .eq('teacher_email', emailController.text)
            .single();

        print('Supabase Response: $response');

        if (response['teacher_password'] == passwordController.text) {
          await myServices.sharedPreferences
              .setString("teacher_id", response["teacher_id"].toString());
          await myServices.sharedPreferences.setString(
              "teacher_firstname", response["teacher_firstname"].toString());
          await myServices.sharedPreferences
              .setString("teacher_email", response["teacher_email"].toString());
          await myServices.sharedPreferences.setString("stepsteacher", "2");
          await myServices.sharedPreferences.setString("step", "1");

          Get.offAllNamed(AppRoute.teacherhome);
        } else {
          Get.snackbar(
            'خطأ',
            'البريد الإلكتروني أو كلمة المرور غير صحيحة',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print(e);
        Get.snackbar(
          'خطأ',
          'حدث خطأ: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
