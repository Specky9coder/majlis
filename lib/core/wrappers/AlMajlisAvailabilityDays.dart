import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisAvailabilityDays.jser.dart';
class AlMajlisAvailabilityDays {
  @Field(decodeFrom: "sun", encodeTo: "sun", isNullable: true, dontDecode: false, dontEncode: false)
  bool sun;
  @Field(decodeFrom: "mon", encodeTo: "mon", isNullable: true, dontDecode: false, dontEncode: false)
  bool mon;
  @Field(decodeFrom: "tue", encodeTo: "tue", isNullable: true, dontDecode: false, dontEncode: false)
  bool tue;
  @Field(decodeFrom: "wed", encodeTo: "wed", isNullable: true, dontDecode: false, dontEncode: false)
  bool wed;
  @Field(decodeFrom: "thu", encodeTo: "thu", isNullable: true, dontDecode: false, dontEncode: false)
  bool thu;
  @Field(decodeFrom: "fri", encodeTo: "fri", isNullable: true, dontDecode: false, dontEncode: false)
  bool fri;
  @Field(decodeFrom: "sat", encodeTo: "sat", isNullable: true, dontDecode: false, dontEncode: false)
  bool sat;

  static final serializer = AlMajlisAvailabilityDaysSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisAvailabilityDays fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisAvailabilityDaysSerializer extends Serializer<AlMajlisAvailabilityDays> with _$AlMajlisAvailabilityDaysSerializer {}