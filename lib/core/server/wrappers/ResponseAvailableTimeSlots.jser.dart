// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseAvailableTimeSlots.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseAvailableTimeSlotsSerializer
    implements Serializer<ResponseAvailableTimeSlots> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  @override
  Map<String, dynamic> toMap(ResponseAvailableTimeSlots model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(
            model.payload,
            (val) =>
                dateTimeUtcProcessor.serialize(val as DateTime) as String));
    return ret;
  }

  @override
  ResponseAvailableTimeSlots fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseAvailableTimeSlots();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<DateTime>(map['payload'] as Iterable,
        (val) => dateTimeUtcProcessor.deserialize(val as String));
    return obj;
  }
}
