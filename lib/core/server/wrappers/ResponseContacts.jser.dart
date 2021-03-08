// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseContacts.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseContactsSerializer
    implements Serializer<ResponseContacts> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<UserNetwork> __userNetworkSerializer;
  Serializer<UserNetwork> get _userNetworkSerializer =>
      __userNetworkSerializer ??= UserNetworkSerializer();
  @override
  Map<String, dynamic> toMap(ResponseContacts model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(model.payload,
            (val) => _userNetworkSerializer.toMap(val as UserNetwork)));
    return ret;
  }

  @override
  ResponseContacts fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseContacts();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<UserNetwork>(map['payload'] as Iterable,
        (val) => _userNetworkSerializer.fromMap(val as Map));
    return obj;
  }
}
