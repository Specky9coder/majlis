// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiUtils.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiUtilsClient implements ApiClient {
  final String basePath = "api/utils";
  Future<ResponseUtils> getUtils() async {
    var req = base.get.path(basePath).path("/config");
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
