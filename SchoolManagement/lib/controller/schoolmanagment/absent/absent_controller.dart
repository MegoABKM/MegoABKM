import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart';

class AbsentController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> classes = [];
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> absentStudents = [];
  bool isLoading = false;
  int? selectedStage;
  int? selectedClassId;
  DateTime? selectedDate;

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
          .select('class_id, class_name, stage')
          .eq('school_id', schoolId);

      classes = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الفصول: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchStudentsAndAbsences(int classId) async {
    if (selectedDate == null) return;

    isLoading = true;
    update();
    try {
      final studentResponse = await supabase
          .from('student')
          .select('student_id, student_firstname, student_lastname')
          .eq('class_id', classId)
          .order('student_firstname', ascending: true);

      students = List<Map<String, dynamic>>.from(studentResponse);

      final absenceResponse = await supabase
          .from('absences')
          .select('student_id, is_absent')
          .eq('class_id', classId)
          .eq('date', selectedDate!.toIso8601String().split('T')[0]);

      final existingAbsences = List<Map<String, dynamic>>.from(absenceResponse);

      absentStudents = students.map((student) {
        final absence = existingAbsences.firstWhere(
          (a) => a['student_id'] == student['student_id'],
          orElse: () => {'is_absent': false},
        );
        return {
          'student_id': student['student_id'],
          'is_absent': absence['is_absent'] as bool,
          'student_firstname': student['student_firstname'],
          'student_lastname': student['student_lastname'],
        };
      }).toList();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب البيانات: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  void toggleAbsence(int studentId, bool isAbsent) {
    final index =
        absentStudents.indexWhere((s) => s['student_id'] == studentId);
    if (index != -1) {
      absentStudents[index]['is_absent'] = isAbsent;
    } else {
      absentStudents.add({
        'student_id': studentId,
        'is_absent': isAbsent,
      });
    }
    update();
  }

  Future<void> submitAbsences(int classId) async {
    if (selectedDate == null) return;

    isLoading = true;
    update();
    try {
      final dateStr = selectedDate!.toIso8601String().split('T')[0];
      // final schoolId = myServices.sharedPreferences.getString("schoolid");

      await supabase
          .from('absences')
          .delete()
          .eq('class_id', classId)
          .eq('date', dateStr);

      final absentRecords = absentStudents
          .where((s) => s['is_absent'])
          .map((s) => {
                'student_id': s['student_id'],
                'class_id': classId,
                'date': dateStr,
                'is_absent': true,
              })
          .toList();

      if (absentRecords.isNotEmpty) {
        await supabase.from('absences').insert(absentRecords);

        for (var absentStudent in absentStudents.where((s) => s['is_absent'])) {
          final studentId = absentStudent['student_id'];
          final studentName =
              '${absentStudent['student_firstname']} ${absentStudent['student_lastname']}';

          final notificationResponse =
              await supabase.from('notifications').insert({
            'student_id': studentId,
            'message': 'تم تسجيل غيابك بتاريخ $dateStr',
            'created_at': DateTime.now().toIso8601String(),
            'is_read': false,
          });
          print(
              'Notification inserted for student $studentId: $notificationResponse');

          final teacherResponse = await supabase
              .from('timetable')
              .select('subjects(teachers(teacher_id))')
              .eq('class_id', classId)
              .limit(1)
              .single();

          final teacherId =
              teacherResponse['subjects']?['teachers']?['teacher_id'];

          if (teacherId != null) {
            final messageResponse = await supabase.from('messages').insert({
              'sender_id': teacherId,
              'receiver_id': studentId,
              'sender_type': 'teacher',
              'receiver_type': 'student',
              'content':
                  'عزيزي $studentName، لقد تم تسجيل غيابك بتاريخ $dateStr. هل يمكنك توضيح السبب؟',
              'sent_at': DateTime.now().toIso8601String(),
              'is_read': false,
            });
            print('Message inserted for student $studentId: $messageResponse');
          }
        }
      }

      Get.snackbar('نجاح', 'تم تحديث الغياب وإرسال الإشعارات بنجاح');
    } catch (e) {
      print('Error in submitAbsences: $e');
      Get.snackbar('خطأ', 'فشل في تحديث الغياب: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  List<Map<String, dynamic>> getClassesForStage(int stage) {
    return classes.where((c) => c['stage'] == stage).toList();
  }
}
