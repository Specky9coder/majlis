
import 'package:almajlis/core/wrappers/AlMajlisState.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisCountry.jser.dart';
class AlMajlisCountry {
  @Field(decodeFrom: "name", encodeTo: "name", isNullable: true, dontDecode: false, dontEncode: false)
  String name;

  @Field(decodeFrom: "iso3", encodeTo: "iso3", isNullable: true, dontDecode: false, dontEncode: false)
  String iso3;

  @Field(decodeFrom: "iso2", encodeTo: "iso2", isNullable: true, dontDecode: false, dontEncode: false)
  String iso2;

  @Field(decodeFrom: "phone_code", encodeTo: "phone_code", isNullable: true, dontDecode: false, dontEncode: false)
  String phoneCode;

  @Field(decodeFrom: "capital", encodeTo: "capital", isNullable: true, dontDecode: false, dontEncode: false)
  String capital;

  @Field(decodeFrom: "currency", encodeTo: "currency", isNullable: true, dontDecode: false, dontEncode: false)
  String currency;

  @Field(decodeFrom: "states", encodeTo: "states", isNullable: true, dontDecode: false, dontEncode: false)
  List<AlMajlisState> states;


  static final serializer = AlMajlisCountrySerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisCountry fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisCountrySerializer extends Serializer<AlMajlisCountry> with _$AlMajlisCountrySerializer {}