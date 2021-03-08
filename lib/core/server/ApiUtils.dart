import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import "wrappers/RequestLogin.dart";
import "wrappers/ResponseLogin.dart";

part 'ApiUtils.jretro.dart';

@GenApiClient(path: "api/utils")
class ApiUtils extends GenericRequestInterceptor with _$ApiUtilsClient {
  final resty.Route base;

  ApiUtils(this.base, sessionInterface): super(base, sessionInterface);

  @GetReq(path: "/config")
  Future<ResponseUtils> getUtils();

}


