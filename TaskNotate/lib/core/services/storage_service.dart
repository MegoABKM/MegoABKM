import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<StorageService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}
