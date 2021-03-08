import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisState.jser.dart';
class AlMajlisState {
  @Field(decodeFrom: "name", encodeTo: "name", isNullable: true, dontDecode: false, dontEncode: false)
  String name;

  @Field(decodeFrom: "id", encodeTo: "id", isNullable: true, dontDecode: false, dontEncode: false)
  int id;

  @Field(decodeFrom: "state_code", encodeTo: "state_code", isNullable: true, dontDecode: false, dontEncode: false)
  String StateCode;




  static final serializer = AlMajlisStateSerializer();


  Map<String, dynamic> toJson() => serializer.toMap(this);
  static AlMajlisState fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class AlMajlisStateSerializer extends Serializer<AlMajlisState> with _$AlMajlisStateSerializer {}