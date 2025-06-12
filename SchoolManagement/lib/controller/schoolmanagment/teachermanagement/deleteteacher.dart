import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteTeacherController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController searchController = TextEditingController();

  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> searchTeachers() async {
    if (searchController.text.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final query = searchController.text.trim();
      print('Searching teachers with query: $query');
      final response = await supabase
          .from('teachers')
          .select('*')
          .eq('school_id', schoolId)
          .or('teacher_firstname.ilike.%$query%,teacher_lastname.ilike.%$query%')
          .order('teacher_firstname');

      searchResults.value = List<Map<String, dynamic>>.from(response);
      print('Found ${searchResults.length} teachers');
    } catch (e) {
      print('Error searching teachers: $e');
      Get.snackbar('خطأ', 'فشل في البحث عن المعلمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTeacher(int teacherId) async {
    isLoading.value = true;
    try {
      print('Deleting teacher with teacher_id: $teacherId');
      await supabase.from('teachers').delete().eq('teacher_id', teacherId);
      searchResults
          .removeWhere((teacher) => teacher['teacher_id'] == teacherId);
      Get.snackbar('نجاح', 'تم حذف المعلم بنجاح');
    } catch (e) {
      print('Error deleting teacher: $e');
      Get.snackbar('خطأ', 'فشل في حذف المعلم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
