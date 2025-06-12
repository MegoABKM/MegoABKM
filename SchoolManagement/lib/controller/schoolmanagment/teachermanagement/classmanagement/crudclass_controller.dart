// lib/controllers/schoolmanagment/classmanagement/crudclass_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart';

class ClassController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> classes = [];
  List<Map<String, dynamic>> students = [];
  bool isLoading = false;
  int? selectedStage;

  final TextEditingController classNameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    isLoading = true;
    update();
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      final response = await supabase
          .from('class')
          .select('class_id, class_name, place, stage')
          .eq('school_id', schoolId);

      classes = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching classes: $e');
      Get.snackbar('خطأ', 'فشل في جلب الفصول: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> createClass() async {
    if (classNameController.text.isEmpty ||
        placeController.text.isEmpty ||
        selectedStage == null) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الحقول');
      return;
    }

    if (selectedStage! < 1 || selectedStage! > 12) {
      Get.snackbar('خطأ', 'المرحلة يجب أن تكون بين 1 و 12');
      return;
    }

    isLoading = true;
    update();
    try {
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      await supabase.from('class').insert({
        'class_name': classNameController.text,
        'place': placeController.text,
        'stage': selectedStage,
        'school_id': int.parse(schoolId),
      });

      Get.snackbar('نجاح', 'تم إنشاء الصف بنجاح');
      clearFields();
      await fetchClasses();
    } catch (e) {
      print('Error creating class: $e');
      Get.snackbar('خطأ', 'فشل في إنشاء الصف: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateClass(int classId, String className, String place) async {
    isLoading = true;
    update();
    try {
      await supabase.from('class').update({
        'class_name': className,
        'place': place,
      }).eq('class_id', classId);

      Get.snackbar('نجاح', 'تم تحديث الصف بنجاح');
      await fetchClasses();
    } catch (e) {
      print('Error updating class: $e');
      Get.snackbar('خطأ', 'فشل في تحديث الصف: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchStudentsInClass(int classId) async {
    isLoading = true;
    update();
    try {
      final response = await supabase
          .from('student')
          .select(
              'student_id, student_firstname, student_lastname, student_gaurdianid, student_phonenumber')
          .eq('class_id', classId)
          .order('student_id', ascending: true);

      students = List<Map<String, dynamic>>.from(response);
      print('Fetched students for class $classId: ${students.length} students');
    } catch (e) {
      print('Error fetching students: $e');
      Get.snackbar('خطأ', 'فشل في جلب الطلاب: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addStudentToClass(int studentId, int classId) async {
    isLoading = true;
    update();
    try {
      final studentResponse = await supabase
          .from('student')
          .select('student_id, class_id')
          .eq('student_id', studentId)
          .maybeSingle();

      print('Student response for ID $studentId: $studentResponse');

      if (studentResponse == null) {
        Get.snackbar('خطأ', 'الطالب غير موجود');
        return;
      }

      final currentClassId = studentResponse['class_id'] as int?;

      if (currentClassId == classId) {
        Get.snackbar('معلومة', 'الطالب موجود بالفعل في هذا الصف');
        return;
      }

      if (currentClassId != null) {
        final classResponse = await supabase
            .from('class')
            .select('class_id, class_name')
            .eq('class_id', currentClassId)
            .single();

        final otherClassName = classResponse['class_name'] as String;
        final otherClassId = classResponse['class_id'] as int;
        Get.snackbar(
          'معلومة',
          'الطالب موجود بالفعل في صف آخر: $otherClassName (ID: $otherClassId)',
          duration: const Duration(seconds: 5),
        );
        return;
      }

      print('Adding student $studentId to class $classId');
      await supabase.from('student').update({
        'class_id': classId,
      }).eq('student_id', studentId);

      Get.snackbar('نجاح', 'تم إضافة الطالب إلى الصف');
      await fetchStudentsInClass(classId);
    } catch (e) {
      print('Error adding student to class: $e');
      Get.snackbar('خطأ', 'فشل في إضافة الطالب: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteStudentFromClass(int studentId, int classId) async {
    isLoading = true;
    update();
    try {
      print('Deleting student $studentId from class $classId');
      await supabase.from('student').update({
        'class_id': null,
      }).eq('student_id', studentId);

      Get.snackbar('نجاح', 'تم حذف الطالب من الصف');
      await fetchStudentsInClass(classId);
    } catch (e) {
      print('Error deleting student from class: $e');
      Get.snackbar('خطأ', 'فشل في حذف الطالب: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<int> getStudentCount(int classId) async {
    try {
      final response = await supabase
          .from('student')
          .select('student_id')
          .eq('class_id', classId);

      return (response as List).length;
    } catch (e) {
      print('Error counting students: $e');
      return 0;
    }
  }

  void clearFields() {
    classNameController.clear();
    placeController.clear();
    selectedStage = null;
    update();
  }

  @override
  void onClose() {
    classNameController.dispose();
    placeController.dispose();
    super.onClose();
  }
}
