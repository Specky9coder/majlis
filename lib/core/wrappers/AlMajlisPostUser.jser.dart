// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisPostUser.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisPostUserSerializer
    implements Serializer<AlMajlisPostUser> {
  @override
  Map<String, dynamic> toMap(AlMajlisPostUser model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'first_name', model.firstName);
    setMapValue(ret, 'last_name', model.lastName);
    setMapValue(ret, 'phone_number', model.phone_number);
    setMapValue(ret, '_id', model.userId);
    setMapValue(ret, 'thumb', model.thumbUrl);
    setMapValue(ret, 'bod', dateTimeUtcProcessor.serialize(model.birthdate));
    setMapValue(ret, 'is_pro', model.isPro);
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(
        ret, 'updatedAt', dateTimeUtcProcessor.serialize(model.updatedAt));
    setMapValue(ret, 'is_public', model.isPublic);
    setMapValue(ret, 'is_online', model.isOnline);
    setMapValue(ret, 'is_verified', model.isVerified);
    setMapValue(ret, 'active', model.active);
    return ret;
  }

  @override
  AlMajlisPostUser fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisPostUser();
    obj.firstName = map['first_name'] as String;
    obj.lastName = map['last_name'] as String;
    obj.phone_number = map['phone_number'] as String;
    obj.userId = map['_id'] as String;
    obj.thumbUrl = map['thumb'] as String;
    obj.birthdate = dateTimeUtcProcessor.deserialize(map['bod'] as String);
    obj.isPro = map['is_pro'] as bool;
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.updatedAt =
        dateTimeUtcProcessor.deserialize(map['updatedAt'] as String);
    obj.isPublic = map['is_public'] as bool;
    obj.isOnline = map['is_online'] as bool;
    obj.isVerified = map['is_verified'] as bool;
    obj.active = map['active'] as bool;
    return obj;
  }
}
