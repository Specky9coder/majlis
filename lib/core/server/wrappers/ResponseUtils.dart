import 'package:almajlis/core/wrappers/AlMajlisUtils.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseUtils.jser.dart';

class ResponseUtils {
  ServerStatus status;
  AlMajlisUtils payload;

  @override
  AlMajlisUtils getPayload() {
    return payload;
  }

}

@GenSerializer()
class ResponseUtilsSerializer extends Serializer<ResponseUtils> with _$ResponseUtilsSerializer {}

