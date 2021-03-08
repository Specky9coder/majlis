// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseBooking.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseBookingSerializer
    implements Serializer<ResponseBooking> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<Booking> __bookingSerializer;
  Serializer<Booking> get _bookingSerializer =>
      __bookingSerializer ??= BookingSerializer();
  @override
  Map<String, dynamic> toMap(ResponseBooking model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(ret, 'payload', _bookingSerializer.toMap(model.payload));
    return ret;
  }

  @override
  ResponseBooking fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBooking();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = _bookingSerializer.fromMap(map['payload'] as Map);
    return obj;
  }
}
