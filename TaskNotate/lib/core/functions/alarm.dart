import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // For Get.snackbar and .tr
import 'package:shared_preferences/shared_preferences.dart';

// Provided setAlarm function (unchanged)
Future<void> setAlarm(DateTime? selectedAlarm, int? lastTaskIdinreased,
    String titlecontroller) async {
  print(
      "setAlarm function called with: selectedAlarm: $selectedAlarm, id: $lastTaskIdinreased, title: '$titlecontroller'"); // Debug
  print("setAlarm triggered".tr);
  if (selectedAlarm == null || lastTaskIdinreased == null) {
    print("No alarm selected or last task ID is null".tr);
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  // Storing ID separately might be redundant if title is always keyed by ID, but kept as per original.
  await prefs.setInt('alarm_${lastTaskIdinreased}_id', lastTaskIdinreased);
  await prefs.setString('alarm_${lastTaskIdinreased}_title', titlecontroller);

  final alarmSettings = AlarmSettings(
    androidFullScreenIntent: true,
    id: lastTaskIdinreased,
    dateTime: selectedAlarm,
    assetAudioPath:
        'assets/alarm.mp3', // Make sure this asset exists and is in pubspec.yaml
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS, // Relevant for iOS
    notificationSettings: NotificationSettings(
      title:
          titlecontroller, // This will be the title of the notification for the foreground service
      body: 'key_notification_body'.tr, // This will be the body
      stopButton: 'key_notification_stop_button'
          .tr, // Text for the stop button on the notification
      icon: 'notification_icon', // Ensure res/drawable/notification_icon exists
    ),
  );

  try {
    bool isSet = await Alarm.set(alarmSettings: alarmSettings);
    if (isSet) {
      if (Get.isSnackbarOpen == false) {
        // Avoid showing multiple snackbars if called rapidly
        Get.snackbar(
          'key_alarm_set'.tr,
          'key_alarm_set_message'.trParams({'s': selectedAlarm.toString()}),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      print("Failed to set the alarm.".tr);
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'key_alarm_error'.tr,
          'key_alarm_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  } catch (e) {
    print("Error setting alarm: $e".tr);
    if (Get.isSnackbarOpen == false) {
      Get.snackbar(
        'key_alarm_error'.tr,
        'key_alarm_error_message'.trParams({'s': e.toString()}),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

// Provided deactivateAlarm function (unchanged)
Future<void> deactivateAlarm(Map<String, String> task) async {
  print('deactivateAlarm called with task: $task');
  final String? alarmIdStr = task['id'];
  if (alarmIdStr != null) {
    final int alarmId = int.parse(alarmIdStr);
    print('Attempting to stop alarm ID: $alarmId');
    // final isRinging = await Alarm.getAlarm(alarmId)?.then((alarm) => alarm != null) ?? false;
    // print('Is alarm $alarmId ringing? $isRinging'); // Or active (scheduled)

    // Check if the specific alarm is indeed active/ringing before trying to stop.
    // Alarm.getAlarm(alarmId) returns null if no alarm with that ID is scheduled.
    bool alarmExists = await Alarm.getAlarm(alarmId) != null;

    try {
      bool stopped = false;
      if (alarmExists) {
        // Only try to stop if it exists
        stopped = await Alarm.stop(alarmId);
        print('Alarm.stop($alarmId) returned: $stopped');
      } else {
        print('Alarm ID: $alarmId not found or already stopped/unscheduled.');
        stopped = true; // Consider it "stopped" if it wasn't active
      }

      if (!stopped) {
        // This fallback can be risky if other alarms are meant to be active.
        // Consider if this is the desired behavior for your app.
        print(
            'Failed to stop alarm ID: $alarmId, attempting to stop all alarms as a fallback.');
        await Alarm.stopAll();
        print('Stopped all alarms (fallback).');
      }
    } catch (e) {
      print('Error stopping alarm ID $alarmId: $e');
      try {
        print('Attempting to stop all alarms due to error.');
        await Alarm.stopAll();
        print('Stopped all alarms (error fallback).');
      } catch (e2) {
        print('Error stopping all alarms: $e2');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarm_${alarmId}_id');
    await prefs.remove('alarm_${alarmId}_title');
    await prefs.remove('current_alarm_id'); // For potential custom tracking
    await prefs.remove('is_alarm_triggered'); // For potential custom tracking
    print('Cleared SharedPreferences for alarm ID: $alarmId');

    // This MethodChannel call is specific to your setup.
    // Ensure you have a handler in your native Android/iOS code if this is needed.
    try {
      const platform = MethodChannel('com.example.tasknotate/alarm');
      await platform.invokeMethod('stopAlarm', {'alarmId': alarmId});
      print('Notified native layer to stop alarm ID: $alarmId');
    } catch (e) {
      print(
          'Error notifying native layer for stopAlarm: $e. This might be expected if not implemented.');
    }
  } else {
    print('Invalid task or task ID in deactivateAlarm: $task');
    try {
      print('Attempting to stop all alarms due to invalid task ID.');
      await Alarm.stopAll();
      print('Stopped all alarms (invalid task ID fallback).');
    } catch (e) {
      print('Error stopping all alarms: $e');
    }
  }
}
