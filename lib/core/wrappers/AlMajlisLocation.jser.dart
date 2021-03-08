// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisLocation.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisLocationSerializer
    implements Serializer<AlMajlisLocation> {
  @override
  Map<String, dynamic> toMap(AlMajlisLocation model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'city', model.city);
    setMapValue(ret, 'country', model.country);
    setMapValue(ret, 'latitude', model.latitude);
    setMapValue(ret, 'longitude', model.longitude);
    setMapValue(ret, 'place_id', model.placeId);
    setMapValue(ret, 'locationName', model.locationName);
    return ret;
  }

  @override
  AlMajlisLocation fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisLocation();
    obj.city = map['city'] as String;
    obj.country = map['country'] as String;
    obj.latitude = map['latitude'] as double;
    obj.longitude = map['longitude'] as double;
    obj.placeId = map['place_id'] as String;
    obj.locationName = map['location_name'] as String;
    return obj;
  }
}
