import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateTeacherController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bornController = TextEditingController();

  var searchResults = <Map<String, dynamic>>[].obs;
  var selectedTeacher = Rx<Map<String, dynamic>?>(null);
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

  void loadTeacherDetails(Map<String, dynamic> teacher) {
    selectedTeacher.value = teacher;
    firstNameController.text = teacher['teacher_firstname'] ?? '';
    lastNameController.text = teacher['teacher_lastname'] ?? '';
    emailController.text = teacher['teacher_email'] ?? '';
    phoneNumberController.text = teacher['teacher_phonenumber'] ?? '';
    bornController.text = teacher['teacher_born'] ?? '';
    Get.back(); // Close search screen
  }

  Future<void> updateTeacher() async {
    if (isLoading.value || selectedTeacher.value == null) return;

    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      print(
          'Updating teacher with ID: ${selectedTeacher.value!['teacher_id']}');
      await supabase.from('teachers').update({
        'teacher_firstname': firstNameController.text,
        'teacher_lastname': lastNameController.text,
        'teacher_email': emailController.text,
        'teacher_phonenumber': phoneNumberController.text,
        'teacher_born': bornController.text,
        'school_id': int.parse(schoolId),
      }).eq('teacher_id', selectedTeacher.value!['teacher_id']);

      Get.snackbar('نجاح', 'تم تحديث بيانات المعلم بنجاح');
      clearForm();
      Get.back();
    } catch (e) {
      print('Error updating teacher: $e');
      Get.snackbar('خطأ', 'فشل في تحديث المعلم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    searchController.clear();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    bornController.clear();
    selectedTeacher.value = null;
    searchResults.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    bornController.dispose();
    super.onClose();
  }
}
