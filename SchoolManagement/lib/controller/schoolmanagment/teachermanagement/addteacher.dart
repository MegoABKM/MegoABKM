import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTeacherController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bornController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> addTeacher() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      await supabase.from('teachers').insert({
        'teacher_firstname': firstNameController.text,
        'teacher_lastname': lastNameController.text,
        'teacher_email': emailController.text,
        'teacher_password': emailController.text,
        'teacher_phonenumber': phoneNumberController.text,
        'teacher_born': bornController.text,
        'school_id': int.parse(schoolId),
      });

      Get.snackbar('نجاح', 'تمت إضافة المعلم بنجاح');
      clearForm();
      Get.back();
    } catch (e) {
      print('Error adding teacher: $e');
      Get.snackbar('خطأ', 'فشل في إضافة المعلم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    bornController.clear();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    bornController.dispose();
    super.onClose();
  }
}
