// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestLogin.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$RequestLoginSerializer implements Serializer<RequestLogin> {
  @override
  Map<String, dynamic> toMap(RequestLogin model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.fcmId);
    return ret;
  }

  @override
  RequestLogin fromMap(Map map) {
    if (map == null) return null;
    final obj = RequestLogin();
    obj.fcmId = map['id'] as String;
    return obj;
  }
}
