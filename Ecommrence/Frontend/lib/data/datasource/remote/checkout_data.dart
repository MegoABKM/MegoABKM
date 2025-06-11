import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class CheckoutData {
  Crud crud;
  CheckoutData(this.crud);

  checkOut(Map data) async {
    var response = await crud.postData(AppLink.checkout, data);
    return response.fold((l) => l, (r) => r);
  }
}
