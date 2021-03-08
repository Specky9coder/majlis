// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiDiscover.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiDiscoverClient implements ApiClient {
  final String basePath = "api/discover";
  Future<ResponseUsers> getUserForDiscover(
      String lat,
      String lng,
      dynamic distance,
      dynamic country,
      dynamic prousers,
      dynamic offset) async {
    var req = base.get
        .path(basePath)
        .path("/")
        .query("lat", lat)
        .query("lng", lng)
        .query("distance", distance)
        .query("country", country)
        .query("prousers", prousers)
        .query("offset", offset);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseUsers> getUsersNearMe(String lat, String lng) async {
    var req = base.get
        .path(basePath)
        .path("/nearme/:lat/:lng")
        .pathParams("lat", lat)
        .pathParams("lng", lng);
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
