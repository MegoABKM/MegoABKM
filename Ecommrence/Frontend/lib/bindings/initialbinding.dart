import 'package:ecommrence/core/class/crud.dart';
import 'package:get/get.dart';

class Initialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
  }
}
