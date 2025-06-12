import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewStudentsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // Observable list to hold students
  RxList<Map<String, dynamic>> students = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('ViewStudentsController initialized');
    fetchStudents(); // Fetch students when the controller initializes
  }

  Future<void> fetchStudents() async {
    isLoading.value = true;
    print('Starting fetchStudents');
    try {
      // Get schoolid from SharedPreferences
      final schoolId = myServices.sharedPreferences.getString("schoolid");
      print('School ID from SharedPreferences: $schoolId');

      if (schoolId == null) {
        print('No schoolid found in SharedPreferences');
        Get.snackbar('خطأ', 'لم يتم العثور على معرف المدرسة');
        return;
      }

      // Fetch students where student_schoolid matches the schoolid
      print('Querying Supabase for students with student_schoolid: $schoolId');
      final response = await supabase
          .from('student')
          .select('*')
          .eq('student_schoolid', schoolId);

      print('Raw response from Supabase: $response');

      // Update the students list
      students.value = List<Map<String, dynamic>>.from(response);
      print('Fetched ${students.length} students for schoolid: $schoolId');
      if (students.isEmpty) {
        print('No students found for schoolid: $schoolId');
      } else {
        print('Students data: ${students.toString()}');
      }
    } catch (e) {
      print('Error fetching students: $e');
      Get.snackbar('خطأ', 'فشل في جلب الطلاب: ${e.toString()}');
    } finally {
      isLoading.value = false;
      print('fetchStudents completed');
    }
  }

  // Refresh students list
  Future<void> refreshStudents() async {
    print('Refreshing students');
    await fetchStudents();
  }
}
