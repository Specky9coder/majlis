// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Booking.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$BookingSerializer implements Serializer<Booking> {
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  @override
  Map<String, dynamic> toMap(Booking model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', model.id);
    setMapValue(ret, 'booked_by', _userSerializer.toMap(model.bookedBy));
    setMapValue(ret, 'booked_for', _userSerializer.toMap(model.bookedFor));
    setMapValue(
        ret, 'meeting_time', dateTimeUtcProcessor.serialize(model.meetingTime));
    setMapValue(ret, 'meeting_charges', model.meetingCharges);
    setMapValue(ret, 'call_status', model.call_status);
    setMapValue(ret, 'booking_amount', model.bookingAmount);
    setMapValue(ret, 'completed', model.completed);
    return ret;
  }

  @override
  Booking fromMap(Map map) {
    if (map == null) return null;
    final obj = Booking();
    obj.id = map['_id'] as String;
    obj.bookedBy = _userSerializer.fromMap(map['booked_by'] as Map);
    obj.bookedFor = _userSerializer.fromMap(map['booked_for'] as Map);
    obj.meetingTime =
        dateTimeUtcProcessor.deserialize(map['meeting_time'] as String);
    obj.meetingCharges = map['meeting_charges'] as num;
    obj.call_status = map['call_status'] as num;
    obj.bookingAmount = map['booking_amount'] as num;
    obj.completed = map['completed'] as bool;
    return obj;
  }
}
