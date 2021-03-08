// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisUtils.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisUtilsSerializer implements Serializer<AlMajlisUtils> {
  @override
  Map<String, dynamic> toMap(AlMajlisUtils model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'user_count', model.userCount);
    setMapValue(ret, 'post_count', model.postCount);
    setMapValue(ret, 'service_charge', model.serviceCharge);
    setMapValue(ret, 'pro_subscription_charge', model.proSubscriptionCharge);
    return ret;
  }

  @override
  AlMajlisUtils fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisUtils();
    obj.userCount = map['user_count'] as int;
    obj.postCount = map['post_count'] as int;
    obj.serviceCharge = map['service_charge'] as num;
    obj.proSubscriptionCharge = map['pro_subscription_charge'] as num;
    return obj;
  }
}
