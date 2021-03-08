// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponsePaymentSuccess.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponsePaymentSuccessSerializer
    implements Serializer<ResponsePaymentSuccess> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  @override
  Map<String, dynamic> toMap(ResponsePaymentSuccess model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', model.payload);
    return ret;
  }

  @override
  ResponsePaymentSuccess fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponsePaymentSuccess();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = map['payload'] as String;
    return obj;
  }
}
