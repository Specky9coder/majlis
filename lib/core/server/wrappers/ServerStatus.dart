import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'ServerStatus.jser.dart';

class ServerStatus {
  String message;
  @Field(decodeFrom: "status_code", encodeTo: "status_code", isNullable: true, dontDecode: false, dontEncode: false)
  int statusCode;
}

@GenSerializer()
class ServerStatusSerializer extends Serializer<ServerStatus> with _$ServerStatusSerializer {}


