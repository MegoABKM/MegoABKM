import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddSubjectController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController subjectNameController = TextEditingController();
  RxList<Map<String, dynamic>> teachers = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedTeacherId = Rx<int?>(null);

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final response = await supabase
          .from('teachers')
          .select('teacher_id, teacher_firstname, teacher_lastname')
          .eq('school_id', schoolId);

      teachers.value = List<Map<String, dynamic>>.from(response);
      print('Fetched ${teachers.length} teachers');
    } catch (e) {
      print('Error fetching teachers: $e');
      Get.snackbar('خطأ', 'فشل في جلب المعلمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSubject() async {
    if (isLoading.value || selectedTeacherId.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار معلم');
      return;
    }

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      await supabase.from('subjects').insert({
        'subject_name': subjectNameController.text,
        'teacher_id':
            selectedTeacherId.value, 
        'school_id': int.parse(schoolId),
      });

      Get.snackbar('نجاح', 'تمت إضافة المادة بنجاح');
      subjectNameController.clear();
      selectedTeacherId.value = null; 
      Get.back();
    } catch (e) {
      print('Error adding subject: $e');
      Get.snackbar('خطأ', 'فشل في إضافة المادة: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    subjectNameController.dispose();
    super.onClose();
  }
}
