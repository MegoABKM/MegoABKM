import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();

  AppLifecycleState? _appLifecycleState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleState =
        WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
    print('Initial app lifecycle state: $_appLifecycleState');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    print('App lifecycle state changed: $state');
  }

  Future init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [
        NotificationChannel(
          channelKey: 'daily_reminder_channel',
          channelName: 'Daily Reminders',
          channelDescription: 'Daily reminders for your tasks',
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          ledColor: const Color(0xFFFF0000),
          channelShowBadge: true,
          criticalAlerts: false,
          icon: 'resource://drawable/notification_icon',
        ),
      ],
      debug: true,
    );

    final granted =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    print('Notification permission granted: $granted');
    print('AwesomeNotifications initialized');

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod: (ReceivedNotification notification) async {
        print('Notification created: ID=${notification.id}');
      },
      onNotificationDisplayedMethod: (ReceivedNotification notification) async {
        if (_appLifecycleState == AppLifecycleState.resumed) {
          await AwesomeNotifications().dismiss(notification.id!);
          print('Dismissed notification ID=${notification.id} in foreground');
          return;
        }
        print('Notification displayed: ID=${notification.id}');
      },
      onDismissActionReceivedMethod: (ReceivedAction action) async {
        print('Notification dismissed: ID=${action.id}');
      },
    );

    return this;
  }

  static Future onActionReceivedMethod(ReceivedAction action) async {
    print(
        'Background action received: ID=${action.id}, Button=${action.buttonKeyPressed}');
  }

  Future scheduleDailyNotifications({bool isTesting = false}) async {
    await cancelAllNotifications(); // Clear existing schedules

    final now = DateTime.now();
    final testTimes = isTesting
        ? [
            now.add(const Duration(seconds: 10)),
            now.add(const Duration(seconds: 20)),
            now.add(const Duration(seconds: 30)),
          ]
        : [
            DateTime(now.year, now.month, now.day, 8, 0).add(
                now.hour > 8 || (now.hour == 8 && now.minute >= 0)
                    ? const Duration(days: 1)
                    : Duration.zero),
            DateTime(now.year, now.month, now.day, 14, 0).add(
                now.hour > 14 || (now.hour == 14 && now.minute >= 0)
                    ? const Duration(days: 1)
                    : Duration.zero),
            DateTime(now.year, now.month, now.day, 19, 0).add(
                now.hour > 19 || (now.hour == 19 && now.minute >= 0)
                    ? const Duration(days: 1)
                    : Duration.zero),
          ];

    await _scheduleNotification(
      id: 1,
      titleKey: 'morning_title',
      bodyKey: 'morning_body',
      scheduledTime: testTimes[0],
    );
    print('Scheduled morning notification at ${testTimes[0]}');

    await _scheduleNotification(
      id: 2,
      titleKey: 'afternoon_title',
      bodyKey: 'afternoon_body',
      scheduledTime: testTimes[1],
    );
    print('Scheduled afternoon notification at ${testTimes[1]}');

    await _scheduleNotification(
      id: 3,
      titleKey: 'before_night_title',
      bodyKey: 'before_night_body',
      scheduledTime: testTimes[2],
    );
    print('Scheduled before night notification at ${testTimes[2]}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_scheduled', true);
    await prefs.setBool('is_testing_notifications', isTesting);
    print(
        'Saved notifications_scheduled: true, is_testing_notifications: $isTesting');

    final active = await AwesomeNotifications().listScheduledNotifications();
    print(
        'Active notifications: ${active.map((n) => "ID=${n.content?.id}, Title=${n.content?.title}, Schedule=${n.schedule?.toMap()}").toList()}');
  }

  Future _scheduleNotification({
    required int id,
    required String titleKey,
    required String bodyKey,
    required DateTime scheduledTime,
  }) async {
    try {
      final isForeground = _appLifecycleState == AppLifecycleState.resumed;
      if (isForeground) {
        print(
            'Skipped displaying notification ID=$id in foreground (Title=$titleKey.tr, Time=$scheduledTime)');
      }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'daily_reminder_channel',
          title: titleKey.tr,
          body: bodyKey.tr,
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          criticalAlert: false,
          wakeUpScreen: false,
          fullScreenIntent: false,
          autoDismissible: false,
          icon: 'resource://drawable/notification_icon',
          displayOnForeground: false,
        ),
        actionButtons: [
          NotificationActionButton(key: 'dismiss', label: 'dismiss'.tr),
          NotificationActionButton(key: 'view', label: 'view_tasks'.tr),
        ],
        schedule: NotificationCalendar(
          year: scheduledTime.year,
          month: scheduledTime.month,
          day: scheduledTime.day,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: scheduledTime.second,
          millisecond: 0,
          allowWhileIdle: true,
          preciseAlarm: true,
        ),
      );
      print(
          'Notification scheduled: ID=$id, Title=$titleKey.tr, Time=$scheduledTime, Foreground=$isForeground');
    } catch (e) {
      print('Error scheduling notification ID=$id: $e');
    }
  }

  Future cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_scheduled', false);
    await prefs.remove('is_testing_notifications');
    print('Cancelled all notifications');
  }

  Future checkAndRescheduleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final isScheduled = prefs.getBool('notifications_scheduled') ?? false;
    final isTesting = prefs.getBool('is_testing_notifications') ?? false;
    print(
        'Checked notifications_scheduled: $isScheduled, is_testing_notifications: $isTesting');
    if (!isScheduled) {
      print('Notifications not scheduled, rescheduling');
      await scheduleDailyNotifications(isTesting: isTesting);
    }
  }

  static Future rescheduleNotifications() async {
    print('Rescheduling notifications at ${DateTime.now()}');
    final notificationService = NotificationService();
    await notificationService.init();
    await notificationService.cancelAllNotifications();
    await notificationService.scheduleDailyNotifications(isTesting: false);
  }
}
