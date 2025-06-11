import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommrence/core/class/statusrequest.dart';
import 'package:ecommrence/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;

//dartz to make the function take two declaration to return two things
class Crud {
// the data that will return is json , json is a map that have data but why we need statusrequest?  if the request (loading,failure) we will know if its working or failure ,/
//it will only return one thing map or statusrequest
  Future<Either<StatusRequest, Map>> postData(linkurl, data) async {
    try {
      // if (await checkInternet()) {
      var response = await http.post(Uri.parse(linkurl), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        print("==============================crud response$response");
        print("==============================crud response body$responsebody");
        return Right(responsebody);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
      // } else {
      //   return const Left(StatusRequest.offlinefailure);
      // }
    } catch (_) {
      return const Left(StatusRequest.serverExeption);
    }
  }
}
