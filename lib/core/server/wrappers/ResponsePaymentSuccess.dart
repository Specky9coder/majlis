import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponsePaymentSuccess.jser.dart';

class ResponsePaymentSuccess {
  ServerStatus status;
  String payload;

  @override
  String getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponsePaymentSuccessSerializer extends Serializer<ResponsePaymentSuccess> with _$ResponsePaymentSuccessSerializer {}

