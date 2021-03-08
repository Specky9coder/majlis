// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisTimeZones.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisTimeZonesSerializer
    implements Serializer<AlMajlisTimeZones> {
  Serializer<AlMajlisTimeZone> __alMajlisTimeZoneSerializer;
  Serializer<AlMajlisTimeZone> get _alMajlisTimeZoneSerializer =>
      __alMajlisTimeZoneSerializer ??= AlMajlisTimeZoneSerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisTimeZones model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'timezones',
        codeIterable(
            model.timeZones,
            (val) =>
                _alMajlisTimeZoneSerializer.toMap(val as AlMajlisTimeZone)));
    return ret;
  }

  @override
  AlMajlisTimeZones fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisTimeZones();
    obj.timeZones = codeIterable<AlMajlisTimeZone>(map['timezones'] as Iterable,
        (val) => _alMajlisTimeZoneSerializer.fromMap(val as Map));
    return obj;
  }
}
