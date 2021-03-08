import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseComments.jser.dart';

class ResponseComments {
  ServerStatus status;
  List<AlMajlisComment> payload;

  @override
  List<AlMajlisComment> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseCommentsSerializer extends Serializer<ResponseComments> with _$ResponseCommentsSerializer {}

