import 'package:almajlis/core/wrappers/AlMajlisState.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisTimeZone.jser.dart';

class AlMajlisTimeZone {
  @Field(
      decodeFrom: "value",
      encodeTo: "value",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String value;

  @Field(
      decodeFrom: "abbr",
      encodeTo: "abbr",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String abbr;

  @Field(
      decodeFrom: "offset",
      encodeTo: "offset",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  num offset;

  @Field(
      decodeFrom: "isdst",
      encodeTo: "isdst",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  bool isdst;

  @Field(
      decodeFrom: "text",
      encodeTo: "text",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  String text;

  @Field(
      decodeFrom: "utc",
      encodeTo: "utc",
      isNullable: true,
      dontDecode: false,
      dontEncode: false)
  List<String> utc;

  static final serializer = AlMajlisTimeZoneSerializer();

  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisTimeZone fromMap(Map map) => serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisTimeZoneSerializer extends Serializer<AlMajlisTimeZone>
    with _$AlMajlisTimeZoneSerializer {}
