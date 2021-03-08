// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisComment.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisCommentSerializer
    implements Serializer<AlMajlisComment> {
  Serializer<AlMajlisPost> __alMajlisPostSerializer;
  Serializer<AlMajlisPost> get _alMajlisPostSerializer =>
      __alMajlisPostSerializer ??= AlMajlisPostSerializer();
  Serializer<AlMajlisPostUser> __alMajlisPostUserSerializer;
  Serializer<AlMajlisPostUser> get _alMajlisPostUserSerializer =>
      __alMajlisPostUserSerializer ??= AlMajlisPostUserSerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisComment model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', model.postId);
    setMapValue(ret, 'post', _alMajlisPostSerializer.toMap(model.post));
    setMapValue(ret, 'user', _alMajlisPostUserSerializer.toMap(model.user));
    setMapValue(ret, 'comment', model.comment);
    setMapValue(ret, 'thumb', model.thumb);
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(ret, 'is_liked', model.isLiked);
    return ret;
  }

  @override
  AlMajlisComment fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisComment();
    obj.postId = map['_id'] as String;
    obj.post = _alMajlisPostSerializer.fromMap(map['post'] as Map);
    obj.user = _alMajlisPostUserSerializer.fromMap(map['user'] as Map);
    obj.comment = map['comment'] as String;
    obj.thumb = map['thumb'] as String;
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.isLiked = map['is_liked'] as bool;
    obj.likeCount = map['like_count'] as int;
    return obj;
  }
}
