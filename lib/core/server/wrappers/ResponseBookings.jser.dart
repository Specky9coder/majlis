// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseBookings.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseBookingsSerializer
    implements Serializer<ResponseBookings> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<Booking> __bookingSerializer;
  Serializer<Booking> get _bookingSerializer =>
      __bookingSerializer ??= BookingSerializer();
  @override
  Map<String, dynamic> toMap(ResponseBookings model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(
            model.payload, (val) => _bookingSerializer.toMap(val as Booking)));
    return ret;
  }

  @override
  ResponseBookings fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBookings();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<Booking>(map['payload'] as Iterable,
        (val) => _bookingSerializer.fromMap(val as Map));
    return obj;
  }
}
