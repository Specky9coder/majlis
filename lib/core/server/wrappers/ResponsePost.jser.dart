// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponsePost.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponsePostSerializer implements Serializer<ResponsePost> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<AlMajlisPost> __alMajlisPostSerializer;
  Serializer<AlMajlisPost> get _alMajlisPostSerializer =>
      __alMajlisPostSerializer ??= AlMajlisPostSerializer();
  @override
  Map<String, dynamic> toMap(ResponsePost model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', _alMajlisPostSerializer.toMap(model.payload));
    return ret;
  }

  @override
  ResponsePost fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponsePost();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = _alMajlisPostSerializer.fromMap(map['payload'] as Map);
    return obj;
  }
}
