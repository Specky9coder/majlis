// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisState.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisStateSerializer implements Serializer<AlMajlisState> {
  @override
  Map<String, dynamic> toMap(AlMajlisState model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'state_code', model.StateCode);
    return ret;
  }

  @override
  AlMajlisState fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisState();
    obj.name = map['name'] as String;
    obj.id = map['id'] as int;
    obj.StateCode = map['state_code'] as String;
    return obj;
  }
}
