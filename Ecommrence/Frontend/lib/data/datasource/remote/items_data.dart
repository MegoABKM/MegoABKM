import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class ItemsData {
  Crud crud;
  ItemsData(this.crud);
  getData(String id, String userid) async {
    var response = await crud
        .postData(AppLink.items, {"id": id.toString(), "userid": userid});
    return response.fold((l) => l, (r) => r);
  }
}
