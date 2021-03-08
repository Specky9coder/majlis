
import 'package:almajlis/core/wrappers/AlMajlisState.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisEducation.jser.dart';
class AlMajlisEducation {
  @Field(decodeFrom: "name", encodeTo: "name", isNullable: true, dontDecode: false, dontEncode: false)
  String university;

  @Field(decodeFrom: "degree", encodeTo: "degree", isNullable: true, dontDecode: false, dontEncode: false)
  String degree;

  @Field(decodeFrom: "work_start", encodeTo: "work_start", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime educationStart;

  @Field(decodeFrom: "work_end", encodeTo: "work_end", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime educationEnd;

  @Field(decodeFrom: "is_current_company", encodeTo: "is_current_company", isNullable: true, dontDecode: false, dontEncode: false)
  bool isCurrent;

  @Field(decodeFrom: "education_url", encodeTo: "education_url", isNullable: true, dontDecode: false, dontEncode: false)
  String educationThumb;

  static final serializer = AlMajlisEducationSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisEducation fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisEducationSerializer extends Serializer<AlMajlisEducation> with _$AlMajlisEducationSerializer {}