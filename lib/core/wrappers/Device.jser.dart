// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Device.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$DeviceSerializer implements Serializer<Device> {
  @override
  Map<String, dynamic> toMap(Device model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'fcm_token', model.fcmToken);
    setMapValue(ret, 'device_id', model.deviceId);
    setMapValue(ret, 'registered_on',
        dateTimeUtcProcessor.serialize(model.registeredOn));
    setMapValue(
        ret, 'last_updated', dateTimeUtcProcessor.serialize(model.lastUpdated));
    return ret;
  }

  @override
  Device fromMap(Map map) {
    if (map == null) return null;
    final obj = Device();
    obj.fcmToken = map['fcm_token'] as String;
    obj.deviceId = map['device_id'] as String;
    obj.registeredOn =
        dateTimeUtcProcessor.deserialize(map['registered_on'] as String);
    obj.lastUpdated =
        dateTimeUtcProcessor.deserialize(map['last_updated'] as String);
    return obj;
  }
}
