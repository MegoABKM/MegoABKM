import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/core/constant/routes.dart';

class SchoolLoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      update();

      try {
        final response = await supabase
            .from('school')
            .select()
            .eq('school_email', emailController.text)
            .single();

        print('Supabase Response: $response');

        if (response['school_password'] == passwordController.text) {
          await myServices.sharedPreferences
              .setString("schoolid", response["school_id"].toString());
          await myServices.sharedPreferences
              .setString("schoolname", response["school_name"].toString());
          await myServices.sharedPreferences
              .setString("schoolemail", response["school_email"].toString());
          await myServices.sharedPreferences.setString("stepschool", "2");
          await myServices.sharedPreferences
              .setString("step", "1"); // Ensure step is set

          Get.offAllNamed(AppRoute.schoolhome);
        } else {
          Get.snackbar(
            'Error',
            'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred: ${e.toString()}',
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
