import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateSubjectController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> teachers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredSubjects = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedTeacherId = Rx<int?>(null);
  Rx<int?> selectedSubjectId = Rx<int?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
    fetchSubjects();
    searchController.addListener(() {
      filterSubjects();
    });
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
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المعلمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubjects() async {
    isLoading.value = true;
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }
      final response = await supabase
          .from('subjects')
          .select(
              'subject_id, subject_name, teacher_id, teachers(teacher_firstname, teacher_lastname)')
          .eq('school_id', schoolId);
      subjects.value = List<Map<String, dynamic>>.from(response);
      filteredSubjects.value = subjects; // Initially show all subjects
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المواد: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void filterSubjects() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredSubjects.value = subjects;
    } else {
      filteredSubjects.value = subjects
          .where((subject) =>
              subject['subject_name'].toLowerCase().contains(query))
          .toList();
    }
  }

  void selectSubject(Map<String, dynamic> subject) {
    selectedSubjectId.value = subject['subject_id'];
    subjectNameController.text = subject['subject_name'];
    selectedTeacherId.value = subject['teacher_id'];
  }

  Future<void> updateSubject() async {
    if (isLoading.value ||
        selectedTeacherId.value == null ||
        selectedSubjectId.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار معلم ومادة');
      return;
    }
    isLoading.value = true;
    try {
      await supabase.from('subjects').update({
        'subject_name': subjectNameController.text,
        'teacher_id': selectedTeacherId.value,
      }).eq('subject_id', selectedSubjectId.value!);
      Get.snackbar('نجاح', 'تم تحديث المادة بنجاح');
      fetchSubjects(); 
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث المادة: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    subjectNameController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
