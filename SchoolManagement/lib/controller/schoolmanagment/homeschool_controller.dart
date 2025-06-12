import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeschoolController extends GetxController {
  final supabase = Supabase.instance.client;

  String? schoolName;
  String? schoolEmail;
  int currentIndex = 0;

  int subjectCount = 0;
  int studentCount = 0;
  int classCount = 0;
  int teacherCount = 0;

  bool isLoading = true;

  void getSchoolData() {
    schoolName = myServices.sharedPreferences.getString("schoolname");
    schoolEmail = myServices.sharedPreferences.getString("schoolemail");
    print('School Name: $schoolName, School Email: $schoolEmail'); // Debug
  }

  Future<void> fetchCounts() async {
    try {
      isLoading = true;
      update();

      final schoolId = myServices.sharedPreferences.getString("schoolid");
      print('School ID from SharedPreferences: $schoolId'); // Debug

      if (schoolId == null) {
        print("School ID not found in shared preferences");
        Get.snackbar('خطأ', 'معرف المدرسة غير موجود');
        isLoading = false;
        update();
        return;
      }

      final subjectResponse = await supabase
          .from('subjects')
          .select('subject_id')
          .eq('school_id', schoolId);
      print('Subjects Response: $subjectResponse'); // Debug
      subjectCount = (subjectResponse as List).length;
      print('Subject Count: $subjectCount'); // Debug

      // Fetch students count
      final studentResponse = await supabase
          .from('student')
          .select('student_id')
          .eq('student_schoolid', schoolId);
      print('Students Response: $studentResponse'); // Debug
      studentCount = (studentResponse as List).length;
      print('Student Count: $studentCount'); // Debug

      // Fetch classes count
      final classResponse = await supabase
          .from('class')
          .select('class_id')
          .eq('school_id', schoolId);
      print('Classes Response: $classResponse'); // Debug
      classCount = (classResponse as List).length;
      print('Class Count: $classCount'); // Debug

      // Fetch teachers count
      final teacherResponse = await supabase
          .from('teachers')
          .select('teacher_id')
          .eq('school_id', schoolId);
      print('Teachers Response: $teacherResponse'); // Debug
      teacherCount = (teacherResponse as List).length;
      print('Teacher Count: $teacherCount'); // Debug

      isLoading = false;
      update();
    } catch (e) {
      print('Error fetching counts: $e');
      Get.snackbar('خطأ', 'فشل في جلب البيانات: $e');
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    getSchoolData();
    fetchCounts();
    super.onInit();
  }
}
