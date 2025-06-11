import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class CartData {
  Crud crud;
  CartData(this.crud);
  addCartItem(String userid, String itemsid) async {
    var response = await crud
        .postData(AppLink.addCartItem, {"usersid": userid, "itemsid": itemsid});
    return response.fold((l) => l, (r) => r);
  }

  removeCartItem(String userid, String itemsid) async {
    var response = await crud.postData(
        AppLink.removeCartItem, {"usersid": userid, "itemsid": itemsid});
    return response.fold((l) => l, (r) => r);
  }

  getcount(String userid, String itemsid) async {
    var response = await crud.postData(
        AppLink.getCountItem, {"usersid": userid, "itemsid": itemsid});
    return response.fold((l) => l, (r) => r);
  }

  viewusercart(String userid) async {
    var response = await crud.postData(AppLink.viewCart, {"usersid": userid});
    return response.fold((l) => l, (r) => r);
  }

  checkCoupon(String? couponName) async {
    var response = await crud.postData(AppLink.checkCoupon, {
      "couponName": couponName,
    });
    return response.fold((l) => l, (r) => r);
  }
}
