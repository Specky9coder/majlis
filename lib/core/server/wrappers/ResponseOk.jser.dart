// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseOk.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseOkSerializer implements Serializer<ResponseOk> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  @override
  Map<String, dynamic> toMap(ResponseOk model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    return ret;
  }

  @override
  ResponseOk fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseOk();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    return obj;
  }
}
