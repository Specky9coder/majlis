import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/ResponseAvailableTimeSlots.dart';
import 'package:almajlis/core/server/wrappers/ResponseBooking.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import "wrappers/RequestLogin.dart";
import "wrappers/ResponseLogin.dart";

part 'ApiBooking.jretro.dart';

@GenApiClient(path: "api/bookings")
class ApiBooking extends GenericRequestInterceptor with _$ApiBookingClient {
  final resty.Route base;

  ApiBooking(this.base, sessionInterface): super(base, sessionInterface);

  @PostReq(path: "/:id/:date")
  Future<ResponsePaymentSuccess> bookMeeting(@PathParam("id")String id, @PathParam("date")DateTime date);

  @GetReq(path: "/slots/:id/:date")
  Future<ResponseAvailableTimeSlots> getAvailableTimeSlots(@PathParam("id")String id, @PathParam("date")DateTime date);

  @PutReq(path: "/start/:id")
  Future<ResponseOk> startBooking(@PathParam("id")String id);

  @PutReq(path: "/left/:id")
  Future<ResponseOk> leftBooking(@PathParam("id")String id);

  @PutReq(path: "/decline/:id")
  Future<ResponseOk> declineBooking(@PathParam("id")String id);

  @GetReq(path: "/:id")
  Future<ResponseBooking> getBookingDetails(@PathParam("id")String id);

}


