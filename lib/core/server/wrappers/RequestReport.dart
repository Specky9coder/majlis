
import 'package:jaguar_serializer/jaguar_serializer.dart';


part 'RequestReport.jser.dart';

class RequestReport {
  @Field(decodeFrom: "report", encodeTo: "report", isNullable: true, dontDecode: false, dontEncode: false)
  String report;
}

@GenSerializer()
class RequestReportSerializer extends Serializer<RequestReport> with _$RequestReportSerializer {}

