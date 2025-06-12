// lib/controller/schoolmanagment/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController schoolLearnTypeController = TextEditingController();
  String? schoolEmail;
  int studentCount = 0;
  bool isLoading = false;
  bool isSaving = false;

  @override
  void onInit() {
    fetchSchoolData();
    super.onInit();
  }

  Future<void> fetchSchoolData() async {
    isLoading = true;
    update();

    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final schoolResponse = await supabase
          .from('school')
          .select('school_name, school_email, school_learntype')
          .eq('school_id', schoolId)
          .single();

      schoolNameController.text = schoolResponse['school_name'];
      schoolEmail = schoolResponse['school_email'];
      schoolLearnTypeController.text = schoolResponse['school_learntype'];

      final studentResponse = await supabase
          .from('student')
          .select('student_id')
          .eq('student_schoolid', schoolId);

      studentCount = (studentResponse as List).length; // Count rows manually

      myServices.sharedPreferences
          .setString("schoolname", schoolResponse['school_name']);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات المدرسة: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveChanges() async {
    isSaving = true;
    update();

    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      await supabase.from('school').update({
        'school_name': schoolNameController.text,
        'school_learntype': schoolLearnTypeController.text,
      }).eq('school_id', schoolId);

      myServices.sharedPreferences
          .setString("schoolname", schoolNameController.text);

      Get.snackbar('نجاح', 'تم تحديث بيانات المدرسة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ التغييرات: ${e.toString()}');
    } finally {
      isSaving = false;
      update();
    }
  }
}
