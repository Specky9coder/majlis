// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisNotification.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisNotificationSerializer
    implements Serializer<AlMajlisNotification> {
  Serializer<AlMajlisComment> __alMajlisCommentSerializer;
  Serializer<AlMajlisComment> get _alMajlisCommentSerializer =>
      __alMajlisCommentSerializer ??= AlMajlisCommentSerializer();
  Serializer<User> __userSerializer;
  Serializer<User> get _userSerializer => __userSerializer ??= UserSerializer();
  Serializer<AlMajlisPost> __alMajlisPostSerializer;
  Serializer<AlMajlisPost> get _alMajlisPostSerializer =>
      __alMajlisPostSerializer ??= AlMajlisPostSerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisNotification model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', model.id);
    setMapValue(ret, 'type', model.type);
    setMapValue(
        ret, 'comment', _alMajlisCommentSerializer.toMap(model.comment));
    setMapValue(ret, 'liked_by', _userSerializer.toMap(model.likeBy));
    setMapValue(ret, 'post', _alMajlisPostSerializer.toMap(model.post));
    setMapValue(ret, 'forwarded_by', _userSerializer.toMap(model.forwardedBy));
    setMapValue(ret, 'forwarded_post',
        _alMajlisPostSerializer.toMap(model.forwardedPost));
    setMapValue(ret, 'message_by', _userSerializer.toMap(model.messageBy));
    setMapValue(
        ret, 'connection_by', _userSerializer.toMap(model.connectionBy));
    setMapValue(ret, 'user', _userSerializer.toMap(model.user));
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(ret, 'read', model.read);
    setMapValue(ret, 'dateType', model.dateType);
    setMapValue(ret, 'datstring', model.datstring);
    return ret;
  }

  @override
  AlMajlisNotification fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisNotification();
    obj.id = map['_id'] as String;
    obj.type = map['type'] as int;
    obj.comment = _alMajlisCommentSerializer.fromMap(map['comment'] as Map);
    obj.likeBy = _userSerializer.fromMap(map['liked_by'] as Map);
    obj.post = _alMajlisPostSerializer.fromMap(map['post'] as Map);
    obj.forwardedBy = _userSerializer.fromMap(map['forwarded_by'] as Map);
    obj.forwardedPost =
        _alMajlisPostSerializer.fromMap(map['forwarded_post'] as Map);
    obj.messageBy = _userSerializer.fromMap(map['message_by'] as Map);
    obj.connectionBy = _userSerializer.fromMap(map['connection_by'] as Map);
    obj.user = _userSerializer.fromMap(map['user'] as Map);
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.read = map['read'] as bool;
    obj.dateType = map['dateType'] as int;
    obj.datstring = map['datstring'] as String;
    return obj;
  }
}
