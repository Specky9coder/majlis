// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisCountries.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisCountriesSerializer
    implements Serializer<AlMajlisCountries> {
  Serializer<AlMajlisCountry> __alMajlisCountrySerializer;
  Serializer<AlMajlisCountry> get _alMajlisCountrySerializer =>
      __alMajlisCountrySerializer ??= AlMajlisCountrySerializer();
  @override
  Map<String, dynamic> toMap(AlMajlisCountries model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'countries',
        codeIterable(model.countries,
            (val) => _alMajlisCountrySerializer.toMap(val as AlMajlisCountry)));
    return ret;
  }

  @override
  AlMajlisCountries fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisCountries();
    obj.countries = codeIterable<AlMajlisCountry>(map['countries'] as Iterable,
        (val) => _alMajlisCountrySerializer.fromMap(val as Map));
    return obj;
  }
}
