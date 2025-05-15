import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:get/get.dart';
import 'package:platform/platform.dart';

Future<void> requestBatteryOptimizationPermission() async {
  if (const LocalPlatform().isAndroid) {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (!status.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
      if (await Permission.ignoreBatteryOptimizations.status.isDenied) {
        print('Battery optimization permission denied, opening settings');
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
          data: 'package:com.example.tasknotate',
        );
        await intent.launch();
        Get.snackbar(
          'Action Required',
          'Please disable battery optimization to ensure notifications work reliably.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    }
    print(
        'Battery optimization permission status: ${await Permission.ignoreBatteryOptimizations.status}');
  }
}

Future<void> requestExactAlarmPermission() async {
  if (const LocalPlatform().isAndroid) {
    final status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request();
      if (await Permission.scheduleExactAlarm.status.isDenied) {
        print('Exact alarm permission denied, opening settings');
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          data: 'package:com.example.tasknotate',
        );
        try {
          await intent.launch();
        } catch (e) {
          await openAppSettings(); // Fallback to app settings
          print('Error launching exact alarm settings: $e');
        }
        Get.snackbar(
          'Action Required',
          'Please allow exact alarms to ensure notifications are timely.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    }
    print(
        'Exact alarm permission status: ${await Permission.scheduleExactAlarm.status}');
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
    if (await Permission.notification.status.isDenied) {
      print('Notification permission denied, opening settings');
      await openAppSettings();
      Get.snackbar(
        'Action Required',
        'Please enable notifications in app settings to receive reminders.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }
  print(
      'Notification permission status: ${await Permission.notification.status}');
}
