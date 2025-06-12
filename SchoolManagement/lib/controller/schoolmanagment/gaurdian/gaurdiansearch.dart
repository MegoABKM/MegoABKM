// lib/controller/schoolmanagment/gaurdian_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart';

class GaurdianController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> students = [];
  Map<String, dynamic>? gaurdianInfo;
  String searchQuery = '';
  bool isLoading = false;

  Future<void> searchStudents() async {
    if (searchQuery.isEmpty) {
      students.clear();
      gaurdianInfo = null;
      update();
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

      // Base query
      var query = supabase
          .from('student')
          .select(
              'student_id, student_firstname, student_lastname, student_gaurdianid')
          .eq('student_schoolid', schoolId);

      int? studentIdQuery;
      try {
        studentIdQuery = int.parse(searchQuery);
      } catch (e) {
        studentIdQuery = null;
      }

      if (studentIdQuery != null) {
        query = query.eq('student_id', studentIdQuery);
      } else {
        query = query.or(
            'student_firstname.ilike.%$searchQuery%,student_lastname.ilike.%$searchQuery%');
      }

      final response = await query.order('student_firstname', ascending: true);

      students = List<Map<String, dynamic>>.from(response);
      gaurdianInfo = null;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في البحث عن الطلاب: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchGaurdianInfo(int studentId) async {
    isLoading = true;
    update();

    try {
      final studentResponse = await supabase
          .from('student')
          .select('student_gaurdianid')
          .eq('student_id', studentId)
          .single();

      final gaurdianId = studentResponse['student_gaurdianid'];

      if (gaurdianId == null) {
        gaurdianInfo = null;
        Get.snackbar('معلومة', 'لم يتم العثور على ولي أمر لهذا الطالب');
        return;
      }

      final gaurdianResponse = await supabase
          .from('gaurdian')
          .select(
              'gaurdian_id, gaurdian_fullname, gaurdian_phonenumber, gaurdian_born, gaurdian_country, gaurdian_city, gaurdian_neighberhood, gaurdian_streetname, gaurdian_buildnumber')
          .eq('gaurdian_id', gaurdianId)
          .single();

      gaurdianInfo = gaurdianResponse;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات ولي الأمر: ${e.toString()}');
      gaurdianInfo = null;
    } finally {
      isLoading = false;
      update();
    }
  }
}
