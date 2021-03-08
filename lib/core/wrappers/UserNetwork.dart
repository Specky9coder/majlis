import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'UserNetwork.jser.dart';
class UserNetwork {
  @Field(decodeFrom: "connected_by", encodeTo: "connected_by", isNullable: true, dontDecode: false, dontEncode: false)
  User connectedBy;
  @Field(decodeFrom: "connected_to", encodeTo: "connected_to", isNullable: true, dontDecode: false, dontEncode: false)
  User connectedTo;

  static final serializer = UserNetworkSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static UserNetwork fromMap(Map map) => serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class UserNetworkSerializer extends Serializer<UserNetwork> with _$UserNetworkSerializer {}
