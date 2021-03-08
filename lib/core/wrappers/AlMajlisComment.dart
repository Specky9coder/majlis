import 'package:almajlis/core/wrappers/AlMajlisCountry.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/AlMajlisPostUser.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisComment.jser.dart';
class AlMajlisComment {
  @Field(decodeFrom: "_id", encodeTo: "_id", isNullable: true, dontDecode: false, dontEncode: false)
  String postId;
  @Field(decodeFrom: "post", encodeTo: "post", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisPost post;
  @Field(decodeFrom: "user", encodeTo: "user", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisPostUser user;
  @Field(decodeFrom: "comment", encodeTo: "comment", isNullable: true, dontDecode: false, dontEncode: false)
  String comment;
  @Field(decodeFrom: "thumb", encodeTo: "thumb", isNullable: true, dontDecode: false, dontEncode: false)
  String thumb;
  @Field(decodeFrom: "createdAt", encodeTo: "createdAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime createdAt;
  @Field(decodeFrom: "is_liked", encodeTo: "is_liked", isNullable: true, dontDecode: false, dontEncode: false)
  bool isLiked;
  @Field(decodeFrom: "like_count", encodeTo: "like_count", isNullable: true, dontDecode: false, dontEncode: true)
  int likeCount;

  static final serializer = AlMajlisCommentSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisComment fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisCommentSerializer extends Serializer<AlMajlisComment> with _$AlMajlisCommentSerializer {}