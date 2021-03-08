import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisUtils.jser.dart';
class AlMajlisUtils {
  @Field(decodeFrom: "user_count", encodeTo: "user_count", isNullable: true, dontDecode: false, dontEncode: false)
  int userCount;

  @Field(decodeFrom: "post_count", encodeTo: "post_count", isNullable: true, dontDecode: false, dontEncode: false)
  int postCount;

  @Field(decodeFrom: "service_charge", encodeTo: "service_charge", isNullable: true, dontDecode: false, dontEncode: false)
  num serviceCharge;

  @Field(decodeFrom: "pro_subscription_charge", encodeTo: "pro_subscription_charge", isNullable: true, dontDecode: false, dontEncode: false)
  num proSubscriptionCharge;






  static final serializer = AlMajlisUtilsSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisUtils fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisUtilsSerializer extends Serializer<AlMajlisUtils> with _$AlMajlisUtilsSerializer {}