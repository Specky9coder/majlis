// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseLogin.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseLoginSerializer implements Serializer<ResponseLogin> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<LoginPayload> __loginPayloadSerializer;
  Serializer<LoginPayload> get _loginPayloadSerializer =>
      __loginPayloadSerializer ??= LoginPayloadSerializer();
  @override
  Map<String, dynamic> toMap(ResponseLogin model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', _loginPayloadSerializer.toMap(model.payload));
    return ret;
  }

  @override
  ResponseLogin fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseLogin();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = _loginPayloadSerializer.fromMap(map['payload'] as Map);
    return obj;
  }
}

abstract class _$LoginPayloadSerializer implements Serializer<LoginPayload> {
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  @override
  Map<String, dynamic> toMap(LoginPayload model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'user', _userSerializer.toMap(model.user));
    setMapValue(ret, 'is_first_login', model.isFirstLogin);
    setMapValue(ret, 'token', model.token);
    return ret;
  }

  @override
  LoginPayload fromMap(Map map) {
    if (map == null) return null;
    final obj = LoginPayload();
    obj.user = _userSerializer.fromMap(map['user'] as Map);
    obj.isFirstLogin = map['is_first_login'] as bool;
    obj.token = map['token'] as String;
    return obj;
  }
}
