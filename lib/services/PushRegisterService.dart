class PushRegisterService {
  static final PushRegisterService _pushRegisterService =
      PushRegisterService._internal();

  factory PushRegisterService() {
    return _pushRegisterService;
  }

  PushRegisterService._internal();
  bool isForeground = true;
  bool fromNotification = false;
  var message;
}
