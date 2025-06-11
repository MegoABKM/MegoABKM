import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class ForgetpasswordData {
  late Crud crud;

  ForgetpasswordData(this.crud);

  postData(String email) async {
    var response = await crud.postData(AppLink.checkemail, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}
