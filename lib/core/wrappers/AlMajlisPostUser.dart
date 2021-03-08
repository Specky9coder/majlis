import 'dart:core';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisPostUser.jser.dart';

class AlMajlisPostUser {
  @Field(decodeFrom: "first_name", encodeTo: "first_name", isNullable: true, dontDecode: false, dontEncode: false)
  String firstName;
  @Field(decodeFrom: "last_name", encodeTo: "last_name", isNullable: true, dontDecode: false, dontEncode: false)
  String lastName;
  @Field(decodeFrom: "phone_number", encodeTo: "phone_number", isNullable: true, dontDecode: false, dontEncode: false)
  String phone_number;
  @Field(decodeFrom: "_id", encodeTo: "_id", isNullable: true, dontDecode: false, dontEncode: false)
  String userId;
  @Field(decodeFrom: "thumb", encodeTo: "thumb", isNullable: true, dontDecode: false, dontEncode: false)
  String thumbUrl;
  @Field(decodeFrom: "bod", encodeTo: "bod", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime birthdate;
  @Field(decodeFrom: "is_pro", encodeTo: "is_pro", isNullable: true, dontDecode: false, dontEncode: false)
  bool isPro;
  @Field(decodeFrom: "createdAt", encodeTo: "createdAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime createdAt;
  @Field(decodeFrom: "updatedAt", encodeTo: "updatedAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime updatedAt;
  @Field(decodeFrom: "is_public", encodeTo: "is_public", isNullable: true, dontDecode: false, dontEncode: false)
  bool isPublic;
  @Field(decodeFrom: "is_online", encodeTo: "is_online", isNullable: true, dontDecode: false, dontEncode: false)
  bool isOnline;
  @Field(decodeFrom: "is_verified", encodeTo: "is_verified", isNullable: true, dontDecode: false, dontEncode: false)
  bool isVerified;
  @Field(decodeFrom: "active", encodeTo: "active", isNullable: true, dontDecode: false, dontEncode: false)
  bool active;

  static final serializer = AlMajlisPostUserSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisPostUser fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisPostUserSerializer extends Serializer<AlMajlisPostUser> with _$AlMajlisPostUserSerializer {}