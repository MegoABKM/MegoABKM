import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  // Future<void> onAlarmActivated(AlarmSettings alarmSettings) async {
  //   // Your custom logic when an alarm activates
  //   print("Alarm with ID ${alarmSettings.id} has been triggered!");

  //   try {
  //     // Example: Update the reminder field to "Not Set"
  //     int response = await sqlDb.updateData(
  //       "UPDATE tasks SET reminder = ? WHERE id = ?",
  //       ["Not Set", alarmSettings.id.toString()],
  //     );

  //     if (response > 0) {
  //       Get.offAll(Home(), transition: Transition.noTransition);
  //       print("Reminder updated to 'Not Set' for task ID ${alarmSettings.id}.");
  //     } else {
  //       print("Failed to update the reminder for task ID ${alarmSettings.id}.");
  //     }
  //   } catch (e) {
  //     print("Error updating reminder for task ID ${alarmSettings.id}: $e");
  //   }
  // }

  Future<MyServices> init() async {
    // await Firebase.initializeApp();
    // subscribeToTopic("news");
    // setupForegroundNotification();
    // await Alarm.init();
    // Alarm.ringStream.stream.listen((alarmSettings) {
    //   onAlarmActivated(alarmSettings);
    // });

    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}

// void setupForegroundNotification() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       print(
//           "📩 Foreground Notification Received: ${message.notification!.title}");

//       // Show a GetX Snackbar
//       Get.snackbar(
//         message.notification!.title ?? "New Notification",
//         message.notification!.body ?? "",
//         snackPosition: SnackPosition.TOP, // Display on top
//         duration: const Duration(seconds: 4), // Snackbar duration
//         backgroundColor: Colors.blue.withOpacity(0.8), // Background color
//         colorText: Colors.white, // Text color
//         borderRadius: 10,
//         margin: const EdgeInsets.all(10),
//         icon: const Icon(Icons.notifications, color: Colors.white),
//       );
//     }
//   });
// }
