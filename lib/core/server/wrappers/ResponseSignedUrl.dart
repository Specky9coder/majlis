
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseSignedUrl.jser.dart';

class ResponseSignedUrl {
  ServerStatus status;
  String payload;

  @override
  String getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseSignedUrlSerializer extends Serializer<ResponseSignedUrl> with _$ResponseSignedUrlSerializer {}

