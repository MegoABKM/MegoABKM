import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart'; // Assuming myServices is here

class TeacherDashboardController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  // RealtimeChannel? _notificationChannel; // Add if teachers have notifications

  List<Map<String, dynamic>> teacherSubjects = [];
  List<Map<String, dynamic>> teacherTimetable = [];
  List<Map<String, dynamic>> teacherSubjectFiles = [];
  // List<Map<String, dynamic>> teacherNotifications = []; // Add if needed
  // List<Map<String, dynamic>> teacherMessages = []; // Add if needed

  bool isLoading = false;

  // Assuming teacher_id is stored in shared preferences
  int? get teacherId =>
      int.tryParse(myServices.sharedPreferences.getString("teacher_id") ?? '');

  @override
  void onInit() {
    super.onInit();
    if (teacherId != null) {
      fetchTeacherDashboardData();
      // subscribeToTeacherNotifications(); // Add if needed
    } else {
      Get.snackbar('خطأ',
          'لم يتم العثور على معرف المعلم. الرجاء تسجيل الدخول مرة أخرى.');
      // Potentially navigate to login screen
    }
  }

  Future<void> fetchTeacherDashboardData() async {
    if (teacherId == null) {
      // This check is a bit redundant due to onInit but good for safety
      Get.snackbar('خطأ', 'لم يتم العثور على معرف المعلم');
      return;
    }

    isLoading = true;
    update();

    try {
      await fetchTeacherSubjectsAndFiles(); // Combines fetching subjects and their files
      await fetchTeacherTimetable();
      // await fetchTeacherNotifications(); // Add if needed
      // await fetchTeacherMessages(); // Add if needed
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات لوحة تحكم المعلم: $e');
      print('Error fetching teacher dashboard data: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTeacherSubjectsAndFiles() async {
    if (teacherId == null) return;

    try {
      // Fetch subjects taught by the teacher
      final subjectsResponse = await supabase
          .from('subjects')
          .select('subject_id, subject_name')
          .eq('teacher_id', teacherId!);

      teacherSubjects = List<Map<String, dynamic>>.from(subjectsResponse);
      print('Fetched teacher subjects: $teacherSubjects');

      if (teacherSubjects.isNotEmpty) {
        final subjectIds =
            teacherSubjects.map((s) => s['subject_id'] as int).toList();
        await fetchSubjectFilesForTeacher(subjectIds);
      } else {
        teacherSubjectFiles = []; // No subjects, so no files
        print('No subjects found for teacher $teacherId, skipping file fetch.');
      }
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب مواد المعلم: $e');
      print('Error fetching teacher subjects: $e');
    }
  }

  Future<void> fetchSubjectFilesForTeacher(List<int> subjectIds) async {
    if (subjectIds.isEmpty) {
      teacherSubjectFiles = [];
      update();
      return;
    }
    try {
      final filesResponse = await supabase
          .from('files')
          .select(
              'id, file_name, file_path, file_type, subject_id, uploaded_at')
          .eq('subject_id', subjectIds); // Use in_ for a list of IDs

      teacherSubjectFiles = List<Map<String, dynamic>>.from(filesResponse);
      print('Fetched subject files for teacher: $teacherSubjectFiles');
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب ملفات المواد للمعلم: $e');
      print('Error fetching subject files for teacher: $e');
    }
  }

  String getDownloadUrl(String filePath) {
    // Assuming your bucket name for subject files is 'subjectfiles'
    return supabase.storage.from('subjectfiles').getPublicUrl(filePath);
  }

  Future<void> fetchTeacherTimetable() async {
    if (teacherId == null) return;
    try {
      // This query directly fetches timetable entries for the teacher's subjects
      // and includes subject_name and class_name
      final response = await supabase.from('timetable').select('''
            timetable_id,
            day,
            time_slot,
            subjects (
              subject_id,
              subject_name
            ),
            class (
              class_id,
              class_name,
              place,
              stage
            )
          ''').eq('subjects.teacher_id', teacherId!) // Filter by teacher_id in the nested subjects table
          // .order('day', ascending: true) // Basic ordering, complex day order might need client-side sort or a view/function
          ;

      final rawTimetable = List<Map<String, dynamic>>.from(response);

      // Sort timetable - more robust sorting for days
      rawTimetable.sort((a, b) {
        int dayCompare = compareDays(a['day'] as String?, b['day'] as String?);
        if (dayCompare != 0) return dayCompare;
        // Then sort by time_slot if days are the same
        return (a['time_slot'] as String? ?? "")
            .compareTo(b['time_slot'] as String? ?? "");
      });

      teacherTimetable = rawTimetable;

      print('Fetched teacher timetable: $teacherTimetable');
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب الجدول الزمني للمعلم: $e');
      print('Error fetching teacher timetable: $e');
    }
  }

  // Helper for sorting days
  int compareDays(String? dayA, String? dayB) {
    const dayOrder = {
      'Sunday': 1,
      'Monday': 2,
      'Tuesday': 3,
      'Wednesday': 4,
      'Thursday': 5,
      'Friday': 6,
      'Saturday': 7
    };
    // Handle null or unknown days by placing them at the end
    int orderA = dayOrder[dayA] ?? 8;
    int orderB = dayOrder[dayB] ?? 8;
    return orderA.compareTo(orderB);
  }

  // --- Optional: Notifications and Messages for Teacher ---
  // You would need to adapt your 'notifications' and 'messages' tables
  // to include a 'teacher_id' or have separate tables like 'teacher_notifications'.

  /*
  Future<void> fetchTeacherNotifications() async {
    if (teacherId == null) return;
    try {
      // Example: Assumes 'notifications' table has a 'teacher_id' field
      // and 'is_for_teacher' boolean field, or a separate table
      final response = await supabase
          .from('notifications') // Or 'teacher_notifications'
          .select('notification_id, message, created_at, is_read')
          .eq('teacher_id', teacherId!) // Filter by teacher_id
          .eq('is_read', false)
          .order('created_at', ascending: false);

      teacherNotifications = List<Map<String, dynamic>>.from(response ?? []);
      update();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب إشعارات المعلم: $e');
    }
  }

  void subscribeToTeacherNotifications() {
    if (teacherId == null) {
      print('Cannot subscribe to teacher notifications: Teacher ID is null');
      return;
    }

    _notificationChannel = supabase
        .channel('public:notifications_teacher') // Use a unique channel name
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications', // Or 'teacher_notifications'
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'teacher_id', // Ensure this column exists and is for teachers
            value: teacherId.toString(),
          ),
          callback: (payload) {
            print('New teacher notification received: $payload');
            final newNotification = payload.newRecord as Map<String, dynamic>;
            teacherNotifications.insert(0, newNotification);
            update();

            Get.snackbar(
              'إشعار جديد للمعلم',
              newNotification['message'] ?? 'لديك إشعار جديد',
              snackPosition: SnackPosition.TOP,
              // ... other snackbar properties
            );
          },
        )
        .subscribe((status, [error]) {
      print('Teacher Notification Subscription status: $status');
      if (error != null) {
        print('Teacher Subscription error: $error');
      }
    });
  }

  Future<void> markTeacherNotificationAsRead(int notificationId) async {
    try {
      await supabase
          .from('notifications') // Or 'teacher_notifications'
          .update({'is_read': true})
          .eq('notification_id', notificationId)
          .eq('teacher_id', teacherId!); // Important: ensure it's the teacher's notification
      teacherNotifications.removeWhere((n) => n['notification_id'] == notificationId);
      update();
    } catch (e) {
      print('Error marking teacher notification as read: $e');
      Get.snackbar('خطأ', 'فشل في تحديث إشعار المعلم: $e');
    }
  }
  */

  @override
  void onClose() {
    // _notificationChannel?.unsubscribe(); // Add if needed
    super.onClose();
  }
}
