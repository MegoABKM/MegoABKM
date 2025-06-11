import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class OrderdetailData {
  Crud crud;
  OrderdetailData(this.crud);

  getData(String? orderid) async {
    var response = await crud.postData(AppLink.orderdetails, {
      "id": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
