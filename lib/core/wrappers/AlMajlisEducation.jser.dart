// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlMajlisEducation.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlMajlisEducationSerializer
    implements Serializer<AlMajlisEducation> {
  @override
  Map<String, dynamic> toMap(AlMajlisEducation model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.university);
    setMapValue(ret, 'degree', model.degree);
    setMapValue(ret, 'work_start',
        dateTimeUtcProcessor.serialize(model.educationStart));
    setMapValue(
        ret, 'work_end', dateTimeUtcProcessor.serialize(model.educationEnd));
    setMapValue(ret, 'is_current_company', model.isCurrent);
    setMapValue(ret, 'education_url', model.educationThumb);
    return ret;
  }

  @override
  AlMajlisEducation fromMap(Map map) {
    if (map == null) return null;
    final obj = AlMajlisEducation();
    obj.university = map['name'] as String;
    obj.degree = map['degree'] as String;
    obj.educationStart =
        dateTimeUtcProcessor.deserialize(map['work_start'] as String);
    obj.educationEnd =
        dateTimeUtcProcessor.deserialize(map['work_end'] as String);
    obj.isCurrent = map['is_current_company'] as bool;
    obj.educationThumb = map['education_url'] as String;
    return obj;
  }
}
