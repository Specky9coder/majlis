// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisAvailabilityDays.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisAvailabilityDaysSerializer
    implements Serializer<AlMajlisAvailabilityDays> {
  @override
  Map<String, dynamic> toMap(AlMajlisAvailabilityDays model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'sun', model.sun);
    setMapValue(ret, 'mon', model.mon);
    setMapValue(ret, 'tue', model.tue);
    setMapValue(ret, 'wed', model.wed);
    setMapValue(ret, 'thu', model.thu);
    setMapValue(ret, 'fri', model.fri);
    setMapValue(ret, 'sat', model.sat);
    return ret;
  }

  @override
  AlMajlisAvailabilityDays fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisAvailabilityDays();
    obj.sun = map['sun'] as bool;
    obj.mon = map['mon'] as bool;
    obj.tue = map['tue'] as bool;
    obj.wed = map['wed'] as bool;
    obj.thu = map['thu'] as bool;
    obj.fri = map['fri'] as bool;
    obj.sat = map['sat'] as bool;
    return obj;
  }
}
