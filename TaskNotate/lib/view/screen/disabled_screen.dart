import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/app_security_service.dart';

class DisabledScreen extends StatelessWidget {
  const DisabledScreen({super.key});

  Future<String> _getDisableMessage() async {
    final prefs = Get.find<AppSecurityService>().prefs;
    return prefs.getString('app_disable_message') ??
        'App is updating try again later'.tr;
  }

  Future<void> _terminateApp() async {
    try {
      const platform = MethodChannel('com.example.tasknotate/alarm');
      await platform.invokeMethod('terminateApp');
      print('App termination requested via platform channel');
    } catch (e) {
      print('Error terminating app: $e');
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChecking = false.obs; // Reactive state for loading

    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        body: GestureDetector(
          onTap: () {}, // Absorb background taps
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20), // Add top padding
                    Text(
                      'App Updating'.tr,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<String>(
                      future: _getDisableMessage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Text(
                          snapshot.data ?? 'App is updating try again later'.tr,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Obx(() => ElevatedButton(
                          onPressed: isChecking.value
                              ? null // Disable button during check
                              : () async {
                                  isChecking.value = true;
                                  try {
                                    final securityService =
                                        Get.find<AppSecurityService>();
                                    final isEnabled = await securityService
                                        .checkAppStatus(forceCheck: true);
                                    if (isEnabled) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final step =
                                          prefs.getString('step') ?? '0';
                                      final route = step == '1'
                                          ? AppRoute.home
                                          : AppRoute.onBoarding;
                                      Get.offAllNamed(route);
                                    } else {
                                      Get.snackbar(
                                        'Action Required'.tr,
                                        'App is still disabled'.tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  } catch (e) {
                                    print('Error checking app status: $e');
                                    Get.snackbar(
                                      'Error'.tr,
                                      'Failed to check app status'.tr,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } finally {
                                    isChecking.value = false;
                                  }
                                },
                          child: isChecking.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('Retry'.tr),
                        )),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        print('Exit button tapped');
                        await _terminateApp();
                      },
                      child: Text('Exit'.tr),
                    ),
                    const SizedBox(height: 20), // Add bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
