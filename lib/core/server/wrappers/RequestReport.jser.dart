// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestReport.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$RequestReportSerializer implements Serializer<RequestReport> {
  @override
  Map<String, dynamic> toMap(RequestReport model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'report', model.report);
    return ret;
  }

  @override
  RequestReport fromMap(Map map) {
    if (map == null) return null;
    final obj = RequestReport();
    obj.report = map['report'] as String;
    return obj;
  }
}
