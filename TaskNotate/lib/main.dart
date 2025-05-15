// main.dart
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/bindings/initialbinding.dart';
import 'package:tasknotate/controller/theme_controller.dart'; // Ensure this is imported
import 'package:tasknotate/core/functions/permission.dart';
import 'package:tasknotate/core/localization/changelocal.dart'; // Ensure this is imported
import 'package:tasknotate/core/localization/translation.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/routes.dart';
import 'package:tasknotate/core/services/app_bootstrap_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);

  // Request permissions
  await requestBatteryOptimizationPermission();
  await requestNotificationPermission();
  await requestExactAlarmPermission();
  print('main.dart: Permission statuses checked.');

  // Initialize StorageService (critical, often needed before other services or UI)
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);

  // Initialize ThemeController and LocalController HERE, BEFORE runApp
  // This ensures they are available for MyApp and GetMaterialApp
  Get.put(ThemeController(), permanent: true);
  Get.put(LocalController(), permanent: true);

  // Get SharedPreferences instance once for bootstrap service
  final prefs = await SharedPreferences.getInstance();

  // Determine initial route using the bootstrap service
  final String determinedInitialRoute =
      await AppBootstrapService.determineInitialRoute(prefs);

  // Setup MethodChannel for calls from Native to Flutter using the bootstrap service
  AppBootstrapService.setupNativeMethodCallHandler();

  // Initialize translations
  await MyTranslation.init();

  // Run the app
  runApp(MyApp(initialRoute: determinedInitialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // ThemeController and LocalController are now initialized in main() and are permanent.
    // The GetBuilder will find ThemeController.
    // Get.find<LocalController>() will find LocalController.
    return GetBuilder<ThemeController>(
      builder: (themeCtrl) => GetMaterialApp(
        translations: MyTranslation(),
        initialBinding:
            InitialBinding(), // This will init OTHER services like AlarmDisplayStateService etc.
        debugShowCheckedModeBanner: false,
        locale: Get.find<LocalController>()
            .language, // This will now find the controller
        fallbackLocale: const Locale('en'),
        theme:
            themeCtrl.currentTheme, // themeCtrl from GetBuilder will be valid
        getPages: routes,
        initialRoute: initialRoute,
      ),
    );
  }
}
