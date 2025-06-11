import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class MyfavoriteData {
  Crud crud;
  MyfavoriteData(this.crud);

  getData(String? userid) async {
    var response = await crud.postData(AppLink.viewfavorite, {
      "usersid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  removedata(String? id) async {
    var response = await crud.postData(AppLink.deletefavorite, {
      "id": id,
    });
    return response.fold((l) => l, (r) => r);
  }
}
