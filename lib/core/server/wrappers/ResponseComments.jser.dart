// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseComments.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseCommentsSerializer
    implements Serializer<ResponseComments> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<AlMajlisComment> __alMajlisCommentSerializer;
  Serializer<AlMajlisComment> get _alMajlisCommentSerializer =>
      __alMajlisCommentSerializer ??= AlMajlisCommentSerializer();
  @override
  Map<String, dynamic> toMap(ResponseComments model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(model.payload,
            (val) => _alMajlisCommentSerializer.toMap(val as AlMajlisComment)));
    return ret;
  }

  @override
  ResponseComments fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseComments();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<AlMajlisComment>(map['payload'] as Iterable,
        (val) => _alMajlisCommentSerializer.fromMap(val as Map));
    return obj;
  }
}
