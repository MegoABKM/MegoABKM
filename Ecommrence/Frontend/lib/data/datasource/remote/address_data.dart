import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class AddressData {
  Crud crud;
  AddressData(this.crud);
  addAddress(String userid, String name, String lat, String long, String city,
      String street) async {
    var response = await crud.postData(AppLink.addAddress, {
      "usersid": userid,
      "name": name,
      "lat": lat,
      "long": long,
      "city": city,
      "street": street
    });
    return response.fold((l) => l, (r) => r);
  }

  viewAddress(String userid) async {
    var response =
        await crud.postData(AppLink.viewAddress, {"address_userid": userid});
    return response.fold((l) => l, (r) => r);
  }

  removeAddress(String addressid) async {
    var response =
        await crud.postData(AppLink.removeAddress, {"addressid": addressid});
    return response.fold((l) => l, (r) => r);
  }

  editAddress(String addressid, String userid, String name, String lat,
      String long, String city, String street) async {
    var response = await crud.postData(AppLink.updateAddress, {
      "addressid": addressid,
      "usersid": userid,
      "name": name,
      "lat": lat,
      "long": long,
      "city": city,
      "street": street
    });
    return response.fold((l) => l, (r) => r);
  }
}
