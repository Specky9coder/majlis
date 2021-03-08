import 'package:almajlis/core/server/wrappers/ServerStatus.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'ResponseOk.jser.dart';

class ResponseOk {
  ServerStatus status;
}

@GenSerializer()
class ResponseOkSerializer extends Serializer<ResponseOk> with _$ResponseOkSerializer {}