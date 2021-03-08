import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseBooking.jser.dart';

class ResponseBooking {
  ServerStatus status;
  Booking payload;

  @override
  Booking getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseBookingSerializer extends Serializer<ResponseBooking> with _$ResponseBookingSerializer {}

