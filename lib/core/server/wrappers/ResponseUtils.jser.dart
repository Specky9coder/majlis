// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseUtils.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseUtilsSerializer implements Serializer<ResponseUtils> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<AlMajlisUtils> __alMajlisUtilsSerializer;
  Serializer<AlMajlisUtils> get _alMajlisUtilsSerializer =>
      __alMajlisUtilsSerializer ??= AlMajlisUtilsSerializer();
  @override
  Map<String, dynamic> toMap(ResponseUtils model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', _alMajlisUtilsSerializer.toMap(model.payload));
    return ret;
  }

  @override
  ResponseUtils fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseUtils();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = _alMajlisUtilsSerializer.fromMap(map['payload'] as Map);
    return obj;
  }
}
