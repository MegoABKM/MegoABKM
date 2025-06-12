import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewSubjectsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
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
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المواد: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
