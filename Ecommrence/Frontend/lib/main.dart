import 'package:ecommrence/bindings/initialbinding.dart';
import 'package:ecommrence/core/localization/changelocal.dart';
import 'package:ecommrence/core/localization/translation.dart';
import 'package:ecommrence/core/services/services.dart';
import 'package:ecommrence/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());

    return GetMaterialApp(
      translations: MyTranslation(),
      initialBinding: Initialbinding(),
      debugShowCheckedModeBanner: false,
      locale: controller.language,
      theme: controller.appTheme,
      getPages: routes,
    );
  }
}
