import "dart:async";
import 'package:almajlis/core/server/Server.dart';

import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';

import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;


part 'ApiUtils.jretro.dart';

@GenApiClient(path: "api/utils")
class ApiUtils extends GenericRequestInterceptor with _$ApiUtilsClient {
  final resty.Route base;

  ApiUtils(this.base, sessionInterface): super(base, sessionInterface);

  @GetReq(path: "/config")
  Future<ResponseUtils> getUtils();

}


