import 'dart:core';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlmajlisPurchesProUserRequest.jser.dart';

class AlmajlisPurchesProUserRequest {
  @Field(
      decodeFrom: "purchaseID",
      encodeTo: "purchaseID",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String purchaseID;
  @Field(
      decodeFrom: "productID",
      encodeTo: "productID",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String productID;
  @Field(
      decodeFrom: "transactionDate",
      encodeTo: "transactionDate",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String transactionDate;

  static final serializer = AlmajlisPurchesProUserRequestSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlmajlisPurchesProUserRequest fromMap(Map map) =>
      serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class AlmajlisPurchesProUserRequestSerializer
    extends Serializer<AlmajlisPurchesProUserRequest>
    with _$AlmajlisPurchesProUserRequestSerializer {}
