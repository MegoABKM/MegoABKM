import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class OrdersArchiveData {
  Crud crud;
  OrdersArchiveData(this.crud);

  getData(String? userid) async {
    var response = await crud.postData(AppLink.archiveorder, {
      "usersid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
