import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseLogin.jser.dart';

class ResponseLogin {
  ServerStatus status;
  LoginPayload payload;

  @override
  LoginPayload getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseLoginSerializer extends Serializer<ResponseLogin> with _$ResponseLoginSerializer {}

class LoginPayload {
  User user;
  @Field(decodeFrom: "is_first_login", encodeTo: "is_first_login", isNullable: true, dontDecode: false, dontEncode: false)
  bool isFirstLogin;
  @Field(decodeFrom: "token", encodeTo: "token", isNullable: true, dontDecode: false, dontEncode: false)
  String token;
}

@GenSerializer()
class LoginPayloadSerializer extends Serializer<LoginPayload> with _$LoginPayloadSerializer {}
