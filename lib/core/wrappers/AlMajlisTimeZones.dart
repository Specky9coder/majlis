import 'package:almajlis/core/wrappers/AlMajlisTimeZone.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisTimeZones.jser.dart';
class AlMajlisTimeZones {
  @Field(decodeFrom: "timezones", encodeTo: "timezones", isNullable: true, dontDecode: false, dontEncode: false)
  List<AlMajlisTimeZone> timeZones;

  static final serializer = AlMajlisTimeZonesSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisTimeZones fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisTimeZonesSerializer extends Serializer<AlMajlisTimeZones> with _$AlMajlisTimeZonesSerializer {}