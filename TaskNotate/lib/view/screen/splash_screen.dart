import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/controller/splash_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loadLottie = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }
    // Delay Lottie loading
    Future.delayed(const Duration(milliseconds: 300), () {
      // Shortened delay
      if (mounted) {
        setState(() {
          _loadLottie = true;
        });
      }
    });
    _navigate();
  }

  Future<void> _performNavigationLogic() async {
    // This is the original navigation logic, now conditional
    try {
      print(
          'SplashScreen: Proceeding with normal splash navigation (app status, step checks).');
      // Ensure services are ready (should be from InitialBinding)
      final StorageService storageService;
      if (Get.isRegistered<StorageService>()) {
        storageService = Get.find<StorageService>();
      } else {
        print('SplashScreen: StorageService not found, initializing.');
        storageService = await Get.putAsync(() => StorageService().init());
      }

      final AppSecurityService securityService;
      if (Get.isRegistered<AppSecurityService>()) {
        securityService = Get.find<AppSecurityService>();
      } else {
        print('SplashScreen: AppSecurityService not found, initializing.');
        securityService =
            await Get.putAsync(() => Future.value(AppSecurityService()));
      }

      final isEnabled = await securityService.checkAppStatus();
      print('SplashScreen: app_is_enabled: $isEnabled');

      if (!isEnabled) {
        print('SplashScreen: App is disabled, navigating to DisabledScreen.');
        await Get.offAllNamed(AppRoute.disabled);
        return;
      }

      final step = storageService.sharedPreferences.getString("step") ?? "0";
      print('SplashScreen: Step value: $step');
      if (step == "1") {
        print('SplashScreen: Navigating to home screen.');
        await Get.offAllNamed(AppRoute.home);
      } else {
        print('SplashScreen: Navigating to onboarding.');
        await Get.offAllNamed(AppRoute.onBoarding);
      }

      // Background check for app status
      final isActuallyEnabled =
          await securityService.checkAppStatus(forceCheck: true);
      final prefsForBgCheck = await SharedPreferences.getInstance();
      await prefsForBgCheck.setBool('app_is_enabled', isActuallyEnabled);
      print(
          'SplashScreen: Background check app_is_enabled: $isActuallyEnabled');

      if (!isActuallyEnabled &&
          Get.currentRoute != AppRoute.disabled &&
          Get.currentRoute != AppRoute.alarmScreen) {
        // Ensure not overriding AlarmScreen

        // Re-check alarm status before navigating to disabled (critical)
        bool alarmStillActive = prefsForBgCheck.getBool(
                AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
            false;
        if (alarmStillActive) {
          print(
              'SplashScreen: Background check found app disabled, BUT ALARM IS ACTIVE. Aborting navigation to DisabledScreen.');
          return;
        }
        print(
            'SplashScreen: App is disabled (background check), navigating to DisabledScreen.');
        await Get.offAllNamed(AppRoute.disabled);
      }
    } catch (e, stackTrace) {
      print(
          'Error in SplashScreen _performNavigationLogic: $e\nStackTrace: $stackTrace');
      // Fallback navigation
      final prefsForFallback = await SharedPreferences.getInstance();
      bool alarmActiveInFallback = prefsForFallback
              .getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
          false;

      if (alarmActiveInFallback) {
        print(
            'SplashScreen: In CATCH block, BUT ALARM IS ACTIVE. Aborting fallback navigation.');
        return;
      }

      try {
        final storageService = Get.isRegistered<StorageService>()
            ? Get.find<StorageService>()
            : await Get.putAsync(
                () => StorageService().init()); // Ensure it exists
        final step = storageService.sharedPreferences.getString("step") ?? "0";
        print('SplashScreen: Fallback navigation, step: $step');
        if (step == "1") {
          await Get.offAllNamed(AppRoute.home);
        } else {
          await Get.offAllNamed(AppRoute.onBoarding);
        }
      } catch (finalError) {
        print(
            'SplashScreen: CRITICAL error in fallback navigation: $finalError. Navigating to onboarding as last resort.');
        if (!(prefsForFallback.getBool(
                AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
            false)) {
          await Get.offAllNamed(AppRoute.onBoarding);
        }
      }
    }
  }

  Future<void> _navigate() async {
    // Check the global alarm state first.
    // This relies on main.dart setting SharedPreferences correctly before runApp,
    // and AlarmDisplayStateService reading it in its init (called by InitialBinding).
    final prefs = await SharedPreferences.getInstance();
    bool isAlarmScreenActiveGlobally =
        prefs.getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
            false;

    print(
        'SplashScreen _navigate: Initial check - isAlarmScreenActiveGlobally from prefs: $isAlarmScreenActiveGlobally');

    // Also check the RxBool from the service if it's registered and initialized
    if (Get.isRegistered<AlarmDisplayStateService>() &&
        AlarmDisplayStateService.to.isAlarmScreenActive.value) {
      isAlarmScreenActiveGlobally =
          true; // If service's live value is true, honor it
      print(
          'SplashScreen _navigate: AlarmDisplayStateService.to.isAlarmScreenActive.value is TRUE.');
    }

    if (isAlarmScreenActiveGlobally) {
      print(
          'SplashScreen: Global alarm flag is TRUE. Splash screen will NOT proceed with its own navigation or major delay.');
      // The GetMaterialApp's initialRoute should have been set to AlarmScreen.
      // This SplashScreen might run very briefly. We just ensure it doesn't navigate away.
      // No Get.offAllNamed here, as that might fight with initialRoute logic.
      return;
    }

    // If no alarm, proceed with the splash screen's typical flow (including the delay)
    print(
        'SplashScreen: No global alarm active. Proceeding with 3-second delay and then navigation logic.');
    await Future.delayed(const Duration(seconds: 3));

    // After delay, re-check alarm status one last time before navigating
    // This is a final safeguard against race conditions.
    final prefsAfterDelay = await SharedPreferences.getInstance();
    bool isAlarmActiveAfterDelay = prefsAfterDelay
            .getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
        false;
    if (Get.isRegistered<AlarmDisplayStateService>() &&
        AlarmDisplayStateService.to.isAlarmScreenActive.value) {
      isAlarmActiveAfterDelay = true;
    }

    if (isAlarmActiveAfterDelay) {
      print(
          'SplashScreen: Alarm became active during splash delay. Aborting splash navigation.');
      return;
    }

    // If still no alarm after delay, perform the main navigation logic
    await _performNavigationLogic();
  }

  @override
  Widget build(BuildContext context) {
    final SplashController? controller = Get.isRegistered<SplashController>()
        ? Get.find<SplashController>()
        : null;

    return Scaffold(
      body: Container(
        // ... (rest of your UI code - no changes needed here) ...
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.appTheme.colorScheme.primary.withOpacity(0.8),
              context.appTheme.colorScheme.surface,
            ],
          ),
        ),
        child: controller != null
            ? Obx(
                () => AnimatedOpacity(
                  opacity: controller.opacity.value,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _loadLottie
                          ? Lottie.asset(
                              'assets/images/splash_screen.json',
                              width: context.scaleConfig.scale(300),
                              height: context.scaleConfig.scale(300),
                              fit: BoxFit.contain,
                              repeat: true,
                            )
                          : SizedBox(
                              width: context.scaleConfig.scale(300),
                              height: context.scaleConfig.scale(300),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                      SizedBox(height: context.scaleConfig.scale(20)),
                      Text(
                        'TaskNotate',
                        style:
                            context.appTheme.textTheme.headlineLarge!.copyWith(
                          color: context.appTheme.colorScheme.onBackground,
                          fontSize: context.scaleConfig.scaleText(36),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: context.scaleConfig.scale(12)),
                      Text(
                        'master_your_day_tasks_notes'.tr,
                        style: context.appTheme.textTheme.titleMedium!.copyWith(
                          color: context.appTheme.colorScheme.onBackground
                              .withOpacity(0.85),
                          fontSize: context.scaleConfig.scaleText(20),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.scaleConfig.scale(40)),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.appTheme.colorScheme.primary,
                        ),
                        strokeWidth: 3.0,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
