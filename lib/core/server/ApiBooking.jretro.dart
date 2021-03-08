// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiBooking.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiBookingClient implements ApiClient {
  final String basePath = "api/bookings";
  Future<ResponsePaymentSuccess> bookMeeting(String id, DateTime date) async {
    var req = base.post
        .path(basePath)
        .path("/:id/:date")
        .pathParams("id", id)
        .pathParams("date", date);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseAvailableTimeSlots> getAvailableTimeSlots(
      String id, DateTime date) async {
    var req = base.get
        .path(basePath)
        .path("/slots/:id/:date")
        .pathParams("id", id)
        .pathParams("date", date);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> startBooking(String id) async {
    var req = base.put.path(basePath).path("/start/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> leftBooking(String id) async {
    var req = base.put.path(basePath).path("/left/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> declineBooking(String id) async {
    var req = base.put.path(basePath).path("/decline/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseBooking> getBookingDetails(String id) async {
    var req = base.get.path(basePath).path("/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
