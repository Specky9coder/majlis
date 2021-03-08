import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisNotification.jser.dart';

class AlMajlisNotification {
  @Field(
      decodeFrom: "_id",
      encodeTo: "_id",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String id;
  @Field(
      decodeFrom: "type",
      encodeTo: "type",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  int type;
  @Field(
      decodeFrom: "comment",
      encodeTo: "comment",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  AlMajlisComment comment;
  @Field(
      decodeFrom: "liked_by",
      encodeTo: "liked_by",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User likeBy;
  @Field(
      decodeFrom: "post",
      encodeTo: "post",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  AlMajlisPost post;
  @Field(
      decodeFrom: "forwarded_by",
      encodeTo: "forwarded_by",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User forwardedBy;
  @Field(
      decodeFrom: "forwarded_post",
      encodeTo: "forwarded_post",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  AlMajlisPost forwardedPost;
  @Field(
      decodeFrom: "message_by",
      encodeTo: "message_by",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User messageBy;
  @Field(
      decodeFrom: "connection_by",
      encodeTo: "connection_by",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User connectionBy;
  @Field(
      decodeFrom: "user",
      encodeTo: "user",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  User user;
  @Field(
      decodeFrom: "createdAt",
      encodeTo: "createdAt",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  DateTime createdAt;
  @Field(
      decodeFrom: "read",
      encodeTo: "read",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  bool read;
  int dateType;
  String datstring;

  static final serializer = AlMajlisNotificationSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisNotification fromMap(Map map) => serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisNotificationSerializer extends Serializer<AlMajlisNotification>
    with _$AlMajlisNotificationSerializer {}
