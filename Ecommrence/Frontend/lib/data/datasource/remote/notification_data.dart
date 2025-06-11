import 'package:ecommrence/core/class/crud.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';

class NotificationData {
  Crud crud;
  NotificationData(this.crud);

  getData(String? userid) async {
    var response = await crud.postData(AppLink.notification, {
      "usersid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
