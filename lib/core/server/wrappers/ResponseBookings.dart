import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseBookings.jser.dart';

class ResponseBookings {
  ServerStatus status;
  List<Booking> payload;

  @override
  List<Booking> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseBookingsSerializer extends Serializer<ResponseBookings> with _$ResponseBookingsSerializer {}

