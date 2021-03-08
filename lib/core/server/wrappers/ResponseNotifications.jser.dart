// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseNotifications.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ResponseNotificationsSerializer
    implements Serializer<ResponseNotifications> {
  Serializer<ServerStatus> __serverStatusSerializer;
  Serializer<ServerStatus> get _serverStatusSerializer =>
      __serverStatusSerializer ??= ServerStatusSerializer();
  Serializer<AlMajlisNotification> __alMajlisNotificationSerializer;
  Serializer<AlMajlisNotification> get _alMajlisNotificationSerializer =>
      __alMajlisNotificationSerializer ??= AlMajlisNotificationSerializer();
  @override
  Map<String, dynamic> toMap(ResponseNotifications model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'status', _serverStatusSerializer.toMap(model.status));
    setMapValue(
        ret,
        'payload',
        codeIterable(
            model.payload,
            (val) => _alMajlisNotificationSerializer
                .toMap(val as AlMajlisNotification)));
    return ret;
  }

  @override
  ResponseNotifications fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseNotifications();
    obj.status = _serverStatusSerializer.fromMap(map['status'] as Map);
    obj.payload = codeIterable<AlMajlisNotification>(map['payload'] as Iterable,
        (val) => _alMajlisNotificationSerializer.fromMap(val as Map));
    return obj;
  }
}
