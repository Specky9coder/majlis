import 'package:almajlis/core/wrappers/AlMajlisPost.dart';

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponsePost.jser.dart';

class ResponsePost {
  ServerStatus status;
  AlMajlisPost payload;

  @override
  AlMajlisPost getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponsePostSerializer extends Serializer<ResponsePost> with _$ResponsePostSerializer {}

