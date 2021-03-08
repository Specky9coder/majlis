import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseUsers.jser.dart';

class ResponseUsers {
  ServerStatus status;
  List<User> payload;

  @override
  List<User> getPayload() {
    return payload;
  }

}

@GenSerializer()
class ResponseUsersSerializer extends Serializer<ResponseUsers> with _$ResponseUsersSerializer {}

