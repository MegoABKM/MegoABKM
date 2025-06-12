import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:schoolmanagement/main.dart';

class StudentNotificationController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RealtimeChannel? _notificationChannel;

  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    subscribeToNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading = true;
    update();
    try {
      final studentId = myServices.sharedPreferences.getString("student_id");
      if (studentId == null) {
        print('Student ID not found in SharedPreferences');
        return;
      }

      final response = await supabase
          .from('notifications')
          .select()
          .eq('student_id', studentId)
          .eq('is_read', false) 
          .order('created_at', ascending: false);

      notifications = List<Map<String, dynamic>>.from(response);
      print('Fetched notifications: $notifications');
    } catch (e) {
      print('Error fetching notifications: $e');
      Get.snackbar('خطأ', 'فشل في جلب الإشعارات: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  void subscribeToNotifications() {
    final studentId = myServices.sharedPreferences.getString("student_id");
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
            value: studentId,
          ),
          callback: (payload) {
            print('New notification received: $payload');
            final newNotification = payload.newRecord as Map<String, dynamic>;
            notifications.insert(
                0, newNotification); 
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

  Future<void> markAsRead(int notificationId) async {
    try {
      await supabase
          .from('notifications')
          .update({'is_read': true}).eq('notification_id', notificationId);
      notifications.removeWhere((n) => n['notification_id'] == notificationId);
      update();
    } catch (e) {
      print('Error marking notification as read: $e');
      Get.snackbar('خطأ', 'فشل في تحديث الإشعار: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    _notificationChannel?.unsubscribe();
    super.onClose();
  }
}
