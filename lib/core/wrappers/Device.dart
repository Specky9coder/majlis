import 'package:jaguar_serializer/jaguar_serializer.dart';


part 'Device.jser.dart';
class Device {
  @Field(decodeFrom: "fcm_token", encodeTo: "fcm_token", isNullable: true, dontDecode: false, dontEncode: false)
  String fcmToken;

  @Field(decodeFrom: "device_id", encodeTo: "device_id", isNullable: true, dontDecode: false, dontEncode: false)
  String deviceId;

  @Field(decodeFrom: "registered_on", encodeTo: "registered_on", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime registeredOn;

  @Field(decodeFrom: "last_updated", encodeTo: "last_updated", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime lastUpdated;

  static final serializer = DeviceSerializer();
  Map<String, dynamic> toJson() => serializer.toMap(this);
  static Device fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class DeviceSerializer extends Serializer<Device> with _$DeviceSerializer {}