import 'package:almajlis/core/wrappers/AlMajlisCountry.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisCountries.jser.dart';
class AlMajlisCountries {
  @Field(decodeFrom: "countries", encodeTo: "countries", isNullable: true, dontDecode: false, dontEncode: false)
  List<AlMajlisCountry> countries;

  static final serializer = AlMajlisCountriesSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisCountries fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisCountriesSerializer extends Serializer<AlMajlisCountries> with _$AlMajlisCountriesSerializer {}