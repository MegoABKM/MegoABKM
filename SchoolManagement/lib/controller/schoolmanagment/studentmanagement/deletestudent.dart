import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteStudentController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController searchController = TextEditingController();

  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> searchStudents() async {
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
      print('Searching students with query: $query');

      final isNumeric = int.tryParse(query) != null;

      final response = isNumeric
          ? await supabase
              .from('student')
              .select('*')
              .eq('student_schoolid', schoolId)
              .eq('student_id', int.parse(query))
          : await supabase
              .from('student')
              .select('*')
              .eq('student_schoolid', schoolId)
              .or('student_firstname.ilike.%$query%,student_lastname.ilike.%$query%')
              .order('student_firstname');

      searchResults.value = List<Map<String, dynamic>>.from(response);
      print('Found ${searchResults.length} students');
    } catch (e) {
      print('Error searching students: $e');
      Get.snackbar('خطأ', 'فشل في البحث عن الطلاب: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStudent(int studentId) async {
    isLoading.value = true;
    try {
      print('Deleting student with student_id: $studentId');
      await supabase.from('student').delete().eq('student_id', studentId);

      searchResults
          .removeWhere((student) => student['student_id'] == studentId);
      print('Student deleted successfully');
      Get.snackbar('نجاح', 'تم حذف الطالب بنجاح');
    } catch (e) {
      print('Error deleting student: $e');
      Get.snackbar('خطأ', 'فشل في حذف الطالب: ${e.toString()}');
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
