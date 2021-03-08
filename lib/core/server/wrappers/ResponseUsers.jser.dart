// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseUsers.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseUsersSerializer implements Serializer<ResponseUsers> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  @override
  Map<String, dynamic> toMap(ResponseUsers model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(
            model.payload, (val) => _userSerializer.toMap(val as User)));
    return ret;
  }

  @override
  ResponseUsers fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseUsers();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<User>(map['payload'] as Iterable,
        (val) => _userSerializer.fromMap(val as Map));
    return obj;
  }
}
