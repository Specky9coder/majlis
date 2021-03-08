// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ServerStatus.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ServerStatusSerializer implements Serializer<ServerStatus> {
  @override
  Map<String, dynamic> toMap(ServerStatus model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'message', model.message);
    setMapValue(ret, 'status_code', model.statusCode);
    return ret;
  }

  @override
  ServerStatus fromMap(Map map) {
    if (map == null) return null;
    final obj = ServerStatus();
    obj.message = map['message'] as String;
    obj.statusCode = map['status_code'] as int;
    return obj;
  }
}
