
import 'package:almajlis/core/wrappers/UserNetwork.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseContacts.jser.dart';

class ResponseContacts {
  ServerStatus status;
  List<UserNetwork> payload;

  @override
  List<UserNetwork> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseContactsSerializer extends Serializer<ResponseContacts> with _$ResponseContactsSerializer {}

