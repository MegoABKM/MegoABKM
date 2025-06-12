import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:schoolmanagement/core/constant/colortheme.dart' as AppThemes;
import 'package:schoolmanagement/core/services/services.dart';
import 'package:schoolmanagement/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const supabaseUrl = '';
const supabaseKey =
    '';
MyServices myServices = Get.find();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  await initialServices();
  MyServices myServices = Get.find();
  String? savedTheme = myServices.sharedPreferences.getString("theme");
  Get.changeTheme(
      savedTheme == "dark" ? AppThemes.darkTheme : AppThemes.lightTheme);
  runApp(MyApp(savedTheme: savedTheme));
}

class MyApp extends StatelessWidget {
  final String? savedTheme;

  const MyApp({super.key, required this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL at the root
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'), // Optional: for Arabic formatting
        theme:
            savedTheme == "dark" ? AppThemes.darkTheme : AppThemes.lightTheme,
        getPages: routes,
      ),
    );
  }
}
