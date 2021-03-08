// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiAuth.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiAuthClient implements ApiClient {
  final String basePath = "api/auth";
  Future<ResponseLogin> userLogin(RequestLogin request) async {
    var req =
        base.post.path(basePath).path("/login").json(jsonConverter.to(request));
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
