
import 'package:almajlis/core/wrappers/AlMajlisNotification.dart';

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'ServerStatus.dart';

part 'ResponseNotifications.jser.dart';

class ResponseNotifications {
  ServerStatus status;
  List<AlMajlisNotification> payload;

  @override
  List<AlMajlisNotification> getPayload() {
    return payload;
  }
}

@GenSerializer()
class ResponseNotificationsSerializer extends Serializer<ResponseNotifications> with _$ResponseNotificationsSerializer {}

