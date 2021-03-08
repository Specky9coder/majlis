// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseSignedUrl.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseSignedUrlSerializer
    implements Serializer<ResponseSignedUrl> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  @override
  Map<String, dynamic> toMap(ResponseSignedUrl model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', model.payload);
    return ret;
  }

  @override
  ResponseSignedUrl fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseSignedUrl();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = map['payload'] as String;
    return obj;
  }
}
