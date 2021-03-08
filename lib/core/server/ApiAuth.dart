import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import "wrappers/RequestLogin.dart";
import "wrappers/ResponseLogin.dart";

part 'ApiAuth.jretro.dart';

@GenApiClient(path: "api/auth")
class ApiAuth extends GenericRequestInterceptor with _$ApiAuthClient {
  final resty.Route base;

  ApiAuth(this.base, sessionInterface): super(base, sessionInterface);

  @PostReq(path: "/login")
  Future<ResponseLogin> userLogin(@AsJson() RequestLogin request);
}


