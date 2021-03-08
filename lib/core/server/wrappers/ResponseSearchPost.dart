import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseSearchPost.jser.dart';

class ResponseSearchPost {
  ServerStatus status;
  List<AlMajlisPost> payload;

  @override
  List<AlMajlisPost> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseSearchPostSerializer extends Serializer<ResponseSearchPost>
    with _$ResponseSearchPostSerializer {}
