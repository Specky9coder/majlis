
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'AlMajlisLocation.jser.dart';
class AlMajlisLocation {
   @Field( decodeFrom: "city", encodeTo: "city", isNullable: true, dontDecode: false, dontEncode: false)
   String city;
   @Field( decodeFrom: "country", encodeTo: "country", isNullable: true, dontDecode: false, dontEncode: false)
   String country;
   @Field( decodeFrom: "latitude", encodeTo: "latitude", isNullable: true, dontDecode: false, dontEncode: false)
   double latitude;
   @Field( decodeFrom: "longitude", encodeTo: "longitude", isNullable: true, dontDecode: false, dontEncode: false)
   double longitude;
   @Field( decodeFrom: "place_id", encodeTo: "place_id", isNullable: true, dontDecode: false, dontEncode: false)
   String placeId;
   @Field( decodeFrom: "location_name", encodeTo: "locationName", isNullable: true, dontDecode: false, dontEncode: false)
   String locationName;

   static final serializer = AlMajlisLocationSerializer();


   Map<String, dynamic> toJson() => serializer.toMap(this);
   static AlMajlisLocation fromMap(Map map) => serializer.fromMap(map);


   String toString() => toJson().toString();
 }

 @GenSerializer()
 class AlMajlisLocationSerializer extends Serializer<AlMajlisLocation> with _$AlMajlisLocationSerializer {}
