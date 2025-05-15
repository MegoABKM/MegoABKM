// bindings/initialbinding.dart
import 'package:get/get.dart';
// DO NOT import ThemeController or LocalController here for Get.put
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/services/alarm_service.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/services/database_service.dart';
import 'package:tasknotate/core/services/notification_service.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/core/services/supabase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ThemeController and LocalController are initialized in main()

    // --- Services ---
    Get.putAsync(() => AlarmDisplayStateService().initService(),
        permanent: true);

    Get.putAsync(() => DatabaseService().init(), permanent: true);
    Get.putAsync(() => SupabaseService().init(), permanent: true);
    Get.putAsync(() => AlarmService().init(), permanent: true);
    Get.putAsync(() async {
      final service = NotificationService();
      await service.init();
      await service.scheduleDailyNotifications(isTesting: false);
      return service;
    }, permanent: true);
    Get.putAsync(() => Future.value(AppSecurityService()), permanent: true);
    Get.putAsync(() async {
      final service = SoundService();
      await service.init();
      return service;
    }, permanent: true);
  }
}
