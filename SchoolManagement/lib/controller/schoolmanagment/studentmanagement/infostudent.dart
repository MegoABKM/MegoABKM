import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentInfoController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  Rx<Map<String, dynamic>> student = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> guardian = Rx<Map<String, dynamic>>({});
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    student.value = Get.arguments['student'] as Map<String, dynamic>;
    print('Student info loaded: ${student.value}');
    fetchGuardianData(); 
  }

  Future<void> fetchGuardianData() async {
    isLoading.value = true;
    try {
      final guardianId =
          student.value['student_gaurdianid']; 
      if (guardianId == null) {
        print('No guardian ID found for student');
        guardian.value = {};
        return;
      }

      print('Fetching guardian data for guardian_id: $guardianId');
      final response = await supabase
          .from('gaurdian') 
          .select('*')
          .eq('gaurdian_id', guardianId) 
          .single();

      guardian.value = response;
      print('Guardian info loaded: ${guardian.value}');
    } catch (e) {
      print('Error fetching guardian data: $e');
      guardian.value = {}; 
      Get.snackbar('خطأ', 'فشل في جلب معلومات ولي الأمر: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
