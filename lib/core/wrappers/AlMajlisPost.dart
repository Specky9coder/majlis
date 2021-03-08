import 'dart:core';
import 'package:almajlis/core/wrappers/AlMajlisLocation.dart';
import 'package:almajlis/core/wrappers/AlMajlisPostUser.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisPost.jser.dart';

class AlMajlisPost {
  @Field(decodeFrom: "_id", encodeTo: "_id", isNullable: true, dontDecode: false, dontEncode: false)
  String postId;
  @Field(decodeFrom: "text", encodeTo: "text", isNullable: true, dontDecode: false, dontEncode: false)
  String text;
  @Field(decodeFrom: "file_type", encodeTo: "file_type", isNullable: true, dontDecode: false, dontEncode: false)
  String fileType;
  @Field(decodeFrom: "file", encodeTo: "file", isNullable: true, dontDecode: false, dontEncode: false)
  String file;
  @Field(decodeFrom: "location", encodeTo: "location", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisLocation location;
  @Field(decodeFrom: "comment_count", encodeTo: "comment_count", isNullable: false, dontDecode: false, dontEncode: false)
  int commentCount;
  @Field(decodeFrom: "like_count", encodeTo: "like_count", isNullable: false, dontDecode: false, dontEncode: false)
  int likeCount;
  @Field(decodeFrom: "share_count", encodeTo: "share_count", isNullable: false, dontDecode: false, dontEncode: false)
  int shareCount;
  @Field(decodeFrom: "view_count", encodeTo: "view_count", isNullable: false, dontDecode: false, dontEncode: false)
  int viewCount;
  @Field(decodeFrom: "expires_on", encodeTo: "expires_on", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime expiresOn;
  @Field(decodeFrom: "createdAt", encodeTo: "createdAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime createdAt;
  @Field(decodeFrom: "expiry", encodeTo: "expiry", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime expiry;
  @Field(decodeFrom: "user", encodeTo: "user", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisPostUser postUser;
  @Field(decodeFrom: "is_liked", encodeTo: "is_liked", isNullable: true, dontDecode: false, dontEncode: false)
  bool isLiked;



  static final serializer = AlMajlisPostSerializer();
  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisPost fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisPostSerializer extends Serializer<AlMajlisPost> with _$AlMajlisPostSerializer {}

