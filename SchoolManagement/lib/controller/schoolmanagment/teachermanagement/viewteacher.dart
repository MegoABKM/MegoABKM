import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewTeachersController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var teachers = <Map<String, dynamic>>[].obs;
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
          .select('*')
          .eq('school_id', schoolId)
          .order('teacher_firstname');

      teachers.value = List<Map<String, dynamic>>.from(response);
      print('Fetched ${teachers.length} teachers');
    } catch (e) {
      print('Error fetching teachers: $e');
      Get.snackbar('خطأ', 'فشل في جلب المعلمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
