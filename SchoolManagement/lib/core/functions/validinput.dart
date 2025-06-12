import 'package:get/get_utils/src/get_utils/get_utils.dart';

String? validInput(String val, int min, int max, String? type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "اسم المستخدم غير صالح"; // "not valid username"
    }
  }

  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "البريد الإلكتروني غير صالح"; // "not valid email"
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "رقم الهاتف غير صالح"; // "not valid phone number"
    }
  }

  if (val.isEmpty) {
    return "لا يمكن أن يكون فارغًا"; // "can't be Empty"
  }

  if (val.length < min) {
    return "لا يمكن أن يكون أقل من $min"; // "can't be less than $min"
  }

  if (val.length > max) {
    return "لا يمكن أن يكون أكبر من $max"; // "can't be larger than $max"
  }
  return null; // Return null if validation passes
}
