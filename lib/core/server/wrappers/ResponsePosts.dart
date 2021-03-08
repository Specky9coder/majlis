import 'package:almajlis/core/wrappers/AlMajlisPost.dart';

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponsePosts.jser.dart';

class ResponsePosts {
  ServerStatus status;
  List<AlMajlisPost> payload;

  @override
  List<AlMajlisPost> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponsePostsSerializer extends Serializer<ResponsePosts> with _$ResponsePostsSerializer {}

