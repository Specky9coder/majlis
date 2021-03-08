// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseUser.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseUserSerializer implements Serializer<ResponseUser> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  @override
  Map<String, dynamic> toMap(ResponseUser model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', _userSerializer.toMap(model.payload));
    return ret;
  }

  @override
  ResponseUser fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseUser();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = _userSerializer.fromMap(map['payload'] as Map);
    return obj;
  }
}
