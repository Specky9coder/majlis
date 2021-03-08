import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'RequestLogin.jser.dart';

class RequestLogin {
  @Field(
      decodeFrom: "id",
      encodeTo: "id",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String fcmId;
}

@GenSerializer()
class RequestLoginSerializer extends Serializer<RequestLogin>
    with _$RequestLoginSerializer {}
