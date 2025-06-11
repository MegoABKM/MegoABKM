import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class OrdersPendingData {
  Crud crud;
  OrdersPendingData(this.crud);

  getData(String? userid) async {
    var response = await crud.postData(AppLink.pendingorder, {
      "usersid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String? orderid) async {
    var response = await crud.postData(AppLink.orderdelete, {
      "id": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
