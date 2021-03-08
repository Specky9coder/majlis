// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisTimeZone.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisTimeZoneSerializer
    implements Serializer<AlMajlisTimeZone> {
  @override
  Map<String, dynamic> toMap(AlMajlisTimeZone model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'value', model.value);
    setMapValue(ret, 'abbr', model.abbr);
    setMapValue(ret, 'offset', model.offset);
    setMapValue(ret, 'isdst', model.isdst);
    setMapValue(ret, 'text', model.text);
    setMapValue(ret, 'utc', codeIterable(model.utc, (val) => val as String));
    return ret;
  }

  @override
  AlMajlisTimeZone fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisTimeZone();
    obj.value = map['value'] as String;
    obj.abbr = map['abbr'] as String;
    obj.offset = map['offset'] as num;
    obj.isdst = map['isdst'] as bool;
    obj.text = map['text'] as String;
    obj.utc =
        codeIterable<String>(map['utc'] as Iterable, (val) => val as String);
    return obj;
  }
}
