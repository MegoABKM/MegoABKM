import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateStudentController extends GetxController {
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

      print('Searching students with query: ${searchController.text}');
      final response = await supabase
          .from('student')
          .select('*')
          .eq('student_schoolid', schoolId)
          .or('student_firstname.ilike.%${searchController.text}%,student_lastname.ilike.%${searchController.text}%')
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
