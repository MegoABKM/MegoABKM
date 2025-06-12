import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart';

class StudentDashboardController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RealtimeChannel? _notificationChannel;

  Map<String, dynamic>? classDetails;
  List<DateTime> absenceDates = [];
  List<DateTime> presentDates = [];
  List<Map<String, dynamic>> timetable = [];
  List<Map<String, dynamic>> subjects = [];
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> subjectFiles = [];
  bool isLoading = false;

  int? get studentId =>
      int.tryParse(myServices.sharedPreferences.getString("student_id") ?? '');

  int get absenceCount => absenceDates.length;

  @override
  void onInit() {
    super.onInit();
    fetchStudentDashboardData();
    subscribeToNotifications();
  }

  Future<void> fetchStudentDashboardData() async {
    if (studentId == null) {
      Get.snackbar('خطأ', 'لم يتم العثور على معرف الطالب');
      return;
    }

    isLoading = true;
    update();

    try {
      final studentResponse = await supabase
          .from('student')
          .select('class_id, class(class_id, class_name, place)')
          .eq('student_id', studentId!)
          .single();

      final classId = studentResponse['class_id'] as int?;
      classDetails = studentResponse['class'] as Map<String, dynamic>?;

      if (classId == null || classDetails == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على فصل للطالب');
        return;
      }

      await fetchAttendance();
      await fetchTimetable(classId);
      await fetchSubjectsWithTeachers(classId);
      await fetchSubjectFiles(classId);
      await fetchNotifications();
      await fetchMessages();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب البيانات: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSubjectFiles(int classId) async {
    try {
      final subjectIds = subjects.map((s) => s['subject_id']).toList();

      if (subjectIds.isEmpty) {
        print('No subjects found for class $classId, skipping file fetch');
        return;
      }

      final response = await supabase
          .from('files')
          .select('id, file_name, file_path, file_type, subject_id')
          .inFilter('subject_id', subjectIds);

      subjectFiles = List<Map<String, dynamic>>.from(response);
      print('Fetched subject files: $subjectFiles');
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب ملفات المواد: $e');
      print('Error fetching subject files: $e');
    }
  }

  String getDownloadUrl(String filePath) {
    return supabase.storage.from('subjectfiles').getPublicUrl(filePath);
  }

  Future<void> fetchAttendance() async {
    try {
      final response = await supabase
          .from('absences')
          .select('date, is_absent')
          .eq('student_id', studentId!);

      final attendance = List<Map<String, dynamic>>.from(response);
      absenceDates = attendance
          .where((a) => a['is_absent'] == true)
          .map((a) => DateTime.parse(a['date'] as String))
          .toList();
      presentDates = attendance
          .where((a) => a['is_absent'] == false)
          .map((a) => DateTime.parse(a['date'] as String))
          .toList();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات الحضور: $e');
    }
  }

  Future<void> fetchTimetable(int classId) async {
    try {
      final response = await supabase
          .from('timetable')
          .select('day, time_slot, subjects(subject_name)')
          .eq('class_id', classId);

      timetable = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الجدول الزمني: $e');
    }
  }

  Future<void> fetchSubjectsWithTeachers(int classId) async {
    try {
      final response = await supabase
          .from('timetable')
          .select(
              'subjects(subject_id, subject_name, teachers(teacher_id, teacher_firstname, teacher_lastname, teacher_phonenumber))')
          .eq('class_id', classId);

      final uniqueSubjects = <String, Map<String, dynamic>>{};
      for (var item in response) {
        final subject = item['subjects'] as Map<String, dynamic>;
        uniqueSubjects[subject['subject_id'].toString()] = {
          'subject_id': subject['subject_id'],
          'subject_name': subject['subject_name'],
          'teacher': subject['teachers'],
        };
      }

      subjects = uniqueSubjects.values.toList();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المواد والمعلمين: $e');
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await supabase
          .from('notifications')
          .select('notification_id, message, created_at, is_read')
          .eq('student_id', studentId!)
          .eq('is_read', false)
          .order('created_at', ascending: false);

      notifications = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الإشعارات: $e');
    }
  }

  Future<void> fetchMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select('message_id, content, sent_at, is_read')
          .eq('student_id', studentId!)
          .order('sent_at', ascending: false);

      messages = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الرسائل: $e');
    }
  }

  void subscribeToNotifications() {
    if (studentId == null) {
      print('Cannot subscribe to notifications: Student ID is null');
      return;
    }

    _notificationChannel = supabase
        .channel('public:notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'student_id',
            value: studentId.toString(),
          ),
          callback: (payload) {
            print('New notification received: $payload');
            final newNotification = payload.newRecord as Map<String, dynamic>;
            notifications.insert(0, newNotification);
            update();

            Get.snackbar(
              'إشعار جديد',
              newNotification['message'] ?? 'لديك إشعار جديد',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          },
        )
        .subscribe((status, [error]) {
      print('Subscription status: $status');
      if (error != null) {
        print('Subscription error: $error');
      }
    });
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await supabase
          .from('notifications')
          .update({'is_read': true}).eq('notification_id', notificationId);
      notifications.removeWhere((n) => n['notification_id'] == notificationId);
      update();
    } catch (e) {
      print('Error marking notification as read: $e');
      Get.snackbar('خطأ', 'فشل في تحديث الإشعار: $e');
    }
  }

  @override
  void onClose() {
    _notificationChannel?.unsubscribe();
    super.onClose();
  }
}
