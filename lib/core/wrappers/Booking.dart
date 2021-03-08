import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'Booking.jser.dart';

class Booking {
  @Field(
      decodeFrom: "_id",
      encodeTo: "_id",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String id;
  @Field(
      decodeFrom: "booked_by",
      encodeTo: "booked_by",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User bookedBy;
  @Field(
      decodeFrom: "booked_for",
      encodeTo: "booked_for",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User bookedFor;
  @Field(
      decodeFrom: "meeting_time",
      encodeTo: "meeting_time",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  DateTime meetingTime;
  @Field(
      decodeFrom: "meeting_charges",
      encodeTo: "meeting_charges",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  num meetingCharges;
  @Field(
      decodeFrom: "call_status",
      encodeTo: "call_status",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  num call_status;
  @Field(
      decodeFrom: "booking_amount",
      encodeTo: "booking_amount",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  num bookingAmount;
  @Field(decodeFrom: "completed",
      encodeTo: "completed",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  bool completed;

  static final serializer = BookingSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static Booking fromMap(Map map) => serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class BookingSerializer extends Serializer<Booking> with _$BookingSerializer {}
