import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/core/services/supabase_service.dart';

class AppSecurityService extends GetxService {
  static const String _isEnabledKey = 'app_is_enabled';
  static const String _messageKey = 'app_disable_message';
  final SupabaseClient supabase = Get.find<SupabaseService>().supabase;
  final SharedPreferences prefs = Get.find<StorageService>().sharedPreferences;
  final _connectivity = Connectivity();
  @override
  void onInit() async {
    super.onInit();
    // Initial check
    await checkAppStatus();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await checkAppStatus(forceCheck: true);
      }
    });
  }

  Future<bool> checkAppStatus({bool forceCheck = false}) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;
      print(
          'Checking app status, isOnline: $isOnline, forceCheck: $forceCheck');

      if (!isOnline && !forceCheck) {
        // Offline: Return cached value or true to allow app use
        final cachedValue = prefs.getBool(_isEnabledKey);
        print('Offline, using cached app_is_enabled: $cachedValue');
        return cachedValue ?? true;
      }

      // Online or forced check: Fetch from Supabase
      final response = await supabase
          .from('app_config')
          .select('is_enabled, message')
          .single()
          .timeout(const Duration(seconds: 10));

      final isEnabled = response['is_enabled'] as bool;
      final message = response['message'] as String;

      await prefs.setBool(_isEnabledKey, isEnabled);
      await prefs.setString(_messageKey, message);
      print(
          'Supabase check successful, app_is_enabled: $isEnabled, message: $message');

      // Redirect to DisabledScreen if disabled and not on AlarmScreen or DisabledScreen
      if (!isEnabled &&
          Get.currentRoute != AppRoute.disabled &&
          Get.currentRoute != '/AlarmScreen') {
        print('App disabled, navigating to DisabledScreen');
        Get.offAllNamed(AppRoute.disabled);
      }

      return isEnabled;
    } catch (e, stackTrace) {
      print('Error checking app status: $e');
      print('StackTrace: $stackTrace');
      // On error, return cached value or true to avoid blocking app
      final cachedValue = prefs.getBool(_isEnabledKey);
      print('Error occurred, using cached app_is_enabled: $cachedValue');
      return cachedValue ?? true;
    }
  }
}
