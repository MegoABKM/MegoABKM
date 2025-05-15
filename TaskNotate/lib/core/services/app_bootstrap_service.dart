// core/services/app_bootstrap_service.dart
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/alarm_display_service.dart'; // For prefsKeyIsAlarmScreenActive

//We use this to make the logic work to connect between the native code and the flutter code using channels
class AppBootstrapService {
  static const _platform = MethodChannel('com.example.tasknotate/alarm');

  static Future<Map<String, dynamic>?> _getInitialAlarmDataFromNative() async {
    try {
      final intentData = await _platform
          .invokeMethod<Map<dynamic, dynamic>>('getInitialIntent');
      print(
          "AppBootstrapService: Received initialIntentData from native: $intentData");
      if (intentData != null &&
          intentData['action'] == 'com.example.tasknotate.ALARM_TRIGGER') {
        final alarmId = intentData['alarmId'] as int?;
        final title = intentData['title'] as String?;
        if (alarmId != null && title != null) {
          return {'id': alarmId, 'title': title};
        } else {
          print(
              "AppBootstrapService: Native alarm intent missing ID or Title. Data: $intentData");
        }
      }
    } catch (e) {
      print(
          'AppBootstrapService: Error getting initial alarm data from native: $e');
    }
    return null;
  }

  static Future<String> determineInitialRoute(SharedPreferences prefs) async {
    String determinedInitialRoute = AppRoute.splashScreen; // Default

    final Map<String, dynamic>? initialAlarmDataFromNative =
        await _getInitialAlarmDataFromNative();

    if (initialAlarmDataFromNative != null) {
      determinedInitialRoute = AppRoute.alarmScreen;
      await prefs.setInt('current_alarm_id', initialAlarmDataFromNative['id']);
      await prefs.setString('alarm_${initialAlarmDataFromNative['id']}_title',
          initialAlarmDataFromNative['title']);
      await prefs.setBool(
          AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
      await prefs.setBool('is_alarm_triggered', true);
      print(
          "AppBootstrapService: Initial route is AlarmScreen due to native intent. Data: $initialAlarmDataFromNative");
    } else {
      bool isGlobalAlarmDisplayFlagStillSet =
          prefs.getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
              false;
      bool isPackageAlarmFlagStillSet =
          prefs.getBool('is_alarm_triggered') ?? false;

      if (isGlobalAlarmDisplayFlagStillSet || isPackageAlarmFlagStillSet) {
        final int? alarmId = prefs.getInt('current_alarm_id');
        final String? alarmTitle = (alarmId != null)
            ? prefs.getString('alarm_${alarmId}_title')
            : null;

        if (alarmId != null && alarmTitle != null) {
          determinedInitialRoute = AppRoute.alarmScreen;
          await prefs.setBool(
              AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
          await prefs.setBool('is_alarm_triggered', true);
          print(
              "AppBootstrapService: Initial route is AlarmScreen due to existing SharedPreferences flags. ID: $alarmId");
        } else {
          print(
              "AppBootstrapService: Alarm flags found in SharedPreferences but no ID/Title. Clearing flags and defaulting to Splash.");
          await prefs
              .remove(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive);
          await prefs.remove('is_alarm_triggered');
          await prefs.remove('current_alarm_id');
        }
      } else {
        print(
            "AppBootstrapService: No alarm indication. Ensuring global alarm display flag is false.");
        await prefs.setBool(
            AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, false);
      }
    }
    return determinedInitialRoute;
  }

  static void setupNativeMethodCallHandler() {
    _platform.setMethodCallHandler((call) async {
      if (call.method == 'showAlarmScreen') {
        final alarmIdFromNative = call.arguments['alarmId'] as int?;
        final titleFromNative = call.arguments['title'] as String?;

        if (alarmIdFromNative != null && titleFromNative != null) {
          print(
              "AppBootstrapService (Handler): 'showAlarmScreen' ID $alarmIdFromNative, Title '$titleFromNative'");

          final currentPrefs = await SharedPreferences.getInstance();
          await currentPrefs.setBool(
              AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
          await currentPrefs.setInt('current_alarm_id', alarmIdFromNative);
          await currentPrefs.setString(
              'alarm_${alarmIdFromNative}_title', titleFromNative);
          await currentPrefs.setBool('is_alarm_triggered', true);

          if (Get.isRegistered<AlarmDisplayStateService>()) {
            // Ensure AlarmDisplayStateService is aware if it's already initialized
            await Get.find<AlarmDisplayStateService>()
                .setAlarmScreenActive(true);
          }

          if (Get.currentRoute != AppRoute.alarmScreen) {
            await Get.offAllNamed(AppRoute.alarmScreen,
                arguments: {'id': alarmIdFromNative, 'title': titleFromNative});
          } else {
            print("AppBootstrapService (Handler): Already on AlarmScreen.");
          }
        } else {
          print(
              "AppBootstrapService (Handler): 'showAlarmScreen' called with null ID or Title.");
        }
      }
    });
  }
}
