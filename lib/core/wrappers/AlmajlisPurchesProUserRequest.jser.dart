// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlmajlisPurchesProUserRequest.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlmajlisPurchesProUserRequestSerializer
    implements Serializer<AlmajlisPurchesProUserRequest> {
  @override
  Map<String, dynamic> toMap(AlmajlisPurchesProUserRequest model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'purchaseID', model.purchaseID);
    setMapValue(ret, 'productID', model.productID);
    setMapValue(ret, 'transactionDate', model.transactionDate);
    return ret;
  }

  @override
  AlmajlisPurchesProUserRequest fromMap(Map map) {
    if (map == null) return null;
    final obj = AlmajlisPurchesProUserRequest();
    obj.purchaseID = map['purchaseID'] as String;
    obj.productID = map['productID'] as String;
    obj.transactionDate = map['transactionDate'] as String;
    return obj;
  }
}
