// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseSearchPost.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseSearchPostSerializer
    implements Serializer<ResponseSearchPost> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<AlMajlisPost> __alMajlisPostSerializer;
  Serializer<AlMajlisPost> get _alMajlisPostSerializer =>
      __alMajlisPostSerializer ??= AlMajlisPostSerializer();
  @override
  Map<String, dynamic> toMap(ResponseSearchPost model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(model.payload,
            (val) => _alMajlisPostSerializer.toMap(val as AlMajlisPost)));
    return ret;
  }

  @override
  ResponseSearchPost fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseSearchPost();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<AlMajlisPost>(map['payload'] as Iterable,
        (val) => _alMajlisPostSerializer.fromMap(val as Map));
    return obj;
  }
}
