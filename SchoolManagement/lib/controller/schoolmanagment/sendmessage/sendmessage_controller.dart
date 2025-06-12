import 'package:get/get.dart';
import 'package:schoolmanagement/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendMessageController extends GetxController {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> students = [];
  List<int> selectedStudents = [];
  bool selectAllStudents = false;
  bool isLoadingStudents = false;
  bool isSendingMessage = false;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      isLoadingStudents = true;
      update();

      final schoolId = myServices.sharedPreferences.getString("schoolid");
      if (schoolId == null) {
        Get.snackbar('خطأ', 'معرف المدرسة غير موجود');
        return;
      }

      final response = await supabase
          .from('student')
          .select('student_id, student_firstname, student_lastname')
          .eq('student_schoolid', schoolId);

      students = List<Map<String, dynamic>>.from(response);
      print('Fetched students: $students'); // Debug
    } catch (e) {
      print('Error fetching students: $e');
      Get.snackbar('خطأ', 'فشل في جلب الطلاب: $e');
    } finally {
      isLoadingStudents = false;
      update();
    }
  }

  void toggleStudentSelection(int studentId, bool isSelected) {
    if (isSelected) {
      selectedStudents.add(studentId);
    } else {
      selectedStudents.remove(studentId);
      selectAllStudents = false;
    }
    update();
  }

  void toggleSelectAll(bool isSelected) {
    selectAllStudents = isSelected;
    if (isSelected) {
      selectedStudents =
          students.map((student) => student['student_id'] as int).toList();
    } else {
      selectedStudents.clear();
    }
    update();
  }

  Future<void> sendMessageToStudents(String message) async {
    try {
      isSendingMessage = true;
      update();

      final messagesToInsert = selectedStudents.map((studentId) {
        return {
          'student_id': studentId, // Changed from receiver_id to student_id
          'content': message,
          'sent_at': DateTime.now().toIso8601String(),
          'is_read': false,
        };
      }).toList();

      await supabase.from('messages').insert(messagesToInsert);

      Get.snackbar('نجاح', 'تم إرسال الرسالة بنجاح');
      Get.back();
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar('خطأ', 'فشل في إرسال الرسالة: $e');
    } finally {
      isSendingMessage = false;
      update();
    }
  }
}
