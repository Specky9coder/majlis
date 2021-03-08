// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisCountry.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisCountrySerializer
    implements Serializer<AlMajlisCountry> {
  Serializer<AlMajlisState> __alMajlisStateSerializer;
  Serializer<AlMajlisState> get _alMajlisStateSerializer =>
      __alMajlisStateSerializer ??= AlMajlisStateSerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisCountry model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'iso3', model.iso3);
    setMapValue(ret, 'iso2', model.iso2);
    setMapValue(ret, 'phone_code', model.phoneCode);
    setMapValue(ret, 'capital', model.capital);
    setMapValue(ret, 'currency', model.currency);
    setMapValue(
        ret,
        'states',
        codeIterable(model.states,
            (val) => _alMajlisStateSerializer.toMap(val as AlMajlisState)));
    return ret;
  }

  @override
  AlMajlisCountry fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisCountry();
    obj.name = map['name'] as String;
    obj.iso3 = map['iso3'] as String;
    obj.iso2 = map['iso2'] as String;
    obj.phoneCode = map['phone_code'] as String;
    obj.capital = map['capital'] as String;
    obj.currency = map['currency'] as String;
    obj.states = codeIterable<AlMajlisState>(map['states'] as Iterable,
        (val) => _alMajlisStateSerializer.fromMap(val as Map));
    return obj;
  }
}
