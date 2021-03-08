import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseUser.jser.dart';

class ResponseUser {
  ServerStatus status;
  User payload;

  @override
  User getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseUserSerializer extends Serializer<ResponseUser> with _$ResponseUserSerializer {}

