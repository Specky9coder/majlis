import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseAvailableTimeSlots.jser.dart';

class ResponseAvailableTimeSlots {
  ServerStatus status;
  List<DateTime> payload;

  @override
  List<DateTime> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseAvailableTimeSlotsSerializer extends Serializer<ResponseAvailableTimeSlots> with _$ResponseAvailableTimeSlotsSerializer {}

