// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserNetwork.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserNetworkSerializer implements Serializer<UserNetwork> {
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  @override
  Map<String, dynamic> toMap(UserNetwork model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'connected_by', _userSerializer.toMap(model.connectedBy));
    setMapValue(ret, 'connected_to', _userSerializer.toMap(model.connectedTo));
    return ret;
  }

  @override
  UserNetwork fromMap(Map map) {
    if (map == null) return null;
    final obj = UserNetwork();
    obj.connectedBy = _userSerializer.fromMap(map['connected_by'] as Map);
    obj.connectedTo = _userSerializer.fromMap(map['connected_to'] as Map);
    return obj;
  }
}
