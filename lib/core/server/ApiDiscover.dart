import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import "wrappers/RequestLogin.dart";
import "wrappers/ResponseLogin.dart";

part 'ApiDiscover.jretro.dart';

@GenApiClient(path: "api/discover")
class ApiDiscover extends GenericRequestInterceptor with _$ApiDiscoverClient {
  final resty.Route base;

  ApiDiscover(this.base, sessionInterface): super(base, sessionInterface);

  @GetReq(path: "/")
  Future<ResponseUsers> getUserForDiscover(@QueryParam("lat")String lat, @QueryParam("lng")String lng, @QueryParam("distance")distance, @QueryParam("country")country, @QueryParam("prousers")prousers, @QueryParam("offset")offset);

  @GetReq(path: "/nearme/:lat/:lng")
  Future<ResponseUsers> getUsersNearMe(@PathParam("lat")String lat, @PathParam("lng")String lng);

}


