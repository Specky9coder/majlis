import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/RequestReport.dart';
import 'package:almajlis/core/server/wrappers/ResponseBookings.dart';
import 'package:almajlis/core/server/wrappers/ResponseContacts.dart';
import 'package:almajlis/core/server/wrappers/ResponseNotifications.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/AlmajlisPurchesProUserRequest.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

part 'ApiUsers.jretro.dart';

@GenApiClient(path: "api/users")
class ApiUsers extends GenericRequestInterceptor with _$ApiUsersClient {
  final resty.Route base;

  ApiUsers(this.base, sessionInterface) : super(base, sessionInterface);

  @GetReq(path: "/me")
  Future<ResponseUser> getUser();

  @PutReq(path: "/me")
  Future<ResponseOk> editUser(@AsJson() User user);

  @PostReq(path: "/me/gopro")
  Future<ResponsePaymentSuccess> goPro();

  @GetReq(path: "/:id")
  Future<ResponseUser> getUserProfile(@PathParam("id") String id);

  @PostReq(path: "/add/:id")
  Future<ResponseOk> addConnection(@PathParam("id") String id);

  @PostReq(path: "/remove/:id")
  Future<ResponseOk> removeConnection(@PathParam("id") String userId);

  @GetReq(path: "/search/:query")
  Future<ResponseUsers> searchUsers(
      @PathParam("query") String searchString, @QueryParam("offset") offset);

  @GetReq(path: "/me/meetings")
  Future<ResponseBookings> getMeetings();

  @GetReq(path: "/me/bookings")
  Future<ResponseBookings> getGreetings();

  @PutReq(path: "/me/location/:lat/:lng")
  Future<ResponseOk> updateLocation(
      @PathParam("lat") String lat, @PathParam("lng") String lng);

  @PutReq(path: "/me/fcm/:token")
  Future<ResponseOk> updateFcm(@PathParam("token") String token);

  @GetReq(path: "/me/notifications/:last_notification_time")
  Future<ResponseNotifications> getNotifications(
      @PathParam("last_notification_time") DateTime timeStamp);

  @PostReq(path: "/me/newmessage/:id")
  Future<ResponseOk> newMessage(@PathParam("id") String id);

  @PostReq(path: "/me/newshare/:id")
  Future<ResponseOk> newShare(@PathParam("id") String id);

  @PostReq(path: "/me/newforward/:id")
  Future<ResponseOk> newForward(@PathParam("id") String id);

  @PostReq(path: "/me/newcall/:id")
  Future<ResponseOk> newCall(@PathParam("id") String id);

  @PostReq(path: "/report/:id")
  Future<ResponseOk> report(
      @AsJson() RequestReport request, @PathParam("id") String id);

  @GetReq(path: "/me/contacts")
  Future<ResponseContacts> getContacts();

  @GetReq(path: "/me/invites")
  Future<ResponseContacts> getInvites();

  @PostReq(path: "/me/gopro/applepay")
  Future<ResponseOk> proUser(
      @AsJson() AlmajlisPurchesProUserRequest proUserRequest);
}
