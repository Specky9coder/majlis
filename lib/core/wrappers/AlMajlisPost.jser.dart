// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisPost.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisPostSerializer implements Serializer<AlMajlisPost> {
  Serializer<AlMajlisLocation> __alMajlisLocationSerializer;
  Serializer<AlMajlisLocation> get _alMajlisLocationSerializer =>
      __alMajlisLocationSerializer ??= AlMajlisLocationSerializer();
  Serializer<AlMajlisPostUser> __alMajlisPostUserSerializer;
  Serializer<AlMajlisPostUser> get _alMajlisPostUserSerializer =>
      __alMajlisPostUserSerializer ??= AlMajlisPostUserSerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisPost model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', model.postId);
    setMapValue(ret, 'text', model.text);
    setMapValue(ret, 'file_type', model.fileType);
    setMapValue(ret, 'file', model.file);
    setMapValue(
        ret, 'location', _alMajlisLocationSerializer.toMap(model.location));
    setMapValueIfNotNull(ret, 'comment_count', model.commentCount);
    setMapValueIfNotNull(ret, 'like_count', model.likeCount);
    setMapValueIfNotNull(ret, 'share_count', model.shareCount);
    setMapValueIfNotNull(ret, 'view_count', model.viewCount);
    setMapValue(
        ret, 'expires_on', dateTimeUtcProcessor.serialize(model.expiresOn));
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(ret, 'expiry', dateTimeUtcProcessor.serialize(model.expiry));
    setMapValue(ret, 'user', _alMajlisPostUserSerializer.toMap(model.postUser));
    setMapValue(ret, 'is_liked', model.isLiked);
    return ret;
  }

  @override
  AlMajlisPost fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisPost();
    obj.postId = map['_id'] as String;
    obj.text = map['text'] as String;
    obj.fileType = map['file_type'] as String;
    obj.file = map['file'] as String;
    obj.location = _alMajlisLocationSerializer.fromMap(map['location'] as Map);
    obj.commentCount = map['comment_count'] as int ??
        getJserDefault('commentCount') ??
        obj.commentCount;
    obj.likeCount = map['like_count'] as int ??
        getJserDefault('likeCount') ??
        obj.likeCount;
    obj.shareCount = map['share_count'] as int ??
        getJserDefault('shareCount') ??
        obj.shareCount;
    obj.viewCount = map['view_count'] as int ??
        getJserDefault('viewCount') ??
        obj.viewCount;
    obj.expiresOn =
        dateTimeUtcProcessor.deserialize(map['expires_on'] as String);
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.expiry = dateTimeUtcProcessor.deserialize(map['expiry'] as String);
    obj.postUser = _alMajlisPostUserSerializer.fromMap(map['user'] as Map);
    obj.isLiked = map['is_liked'] as bool;
    return obj;
  }
}
