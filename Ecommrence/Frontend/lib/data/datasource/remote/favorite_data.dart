import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class FavoriteData {
  Crud crud;
  FavoriteData(this.crud);
  addFavorite(String userid, String itemsid) async {
    var response = await crud
        .postData(AppLink.addfavorite, {"usersid": userid, "itemsid": itemsid});
    return response.fold((l) => l, (r) => r);
  }

  removeFavorite(String userid, String itemsid) async {
    var response = await crud.postData(
        AppLink.removefavorite, {"usersid": userid, "itemsid": itemsid});
    return response.fold((l) => l, (r) => r);
  }
}
