// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiUsers.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiUsersClient implements ApiClient {
  final String basePath = "api/users";
  Future<ResponseUser> getUser() async {
    var req = base.get.path(basePath).path("/me");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> editUser(User user) async {
    var req = base.put.path(basePath).path("/me").json(jsonConverter.to(user));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponsePaymentSuccess> goPro() async {
    var req = base.post.path(basePath).path("/me/gopro");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseUser> getUserProfile(String id) async {
    var req = base.get.path(basePath).path("/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> addConnection(String id) async {
    var req = base.post.path(basePath).path("/add/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> removeConnection(String userId) async {
    var req =
        base.post.path(basePath).path("/remove/:id").pathParams("id", userId);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseUsers> searchUsers(String searchString, dynamic offset) async {
    var req = base.get
        .path(basePath)
        .path("/search/:query")
        .pathParams("query", searchString)
        .query("offset", offset);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseBookings> getMeetings() async {
    var req = base.get.path(basePath).path("/me/meetings");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseBookings> getGreetings() async {
    var req = base.get.path(basePath).path("/me/bookings");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> updateLocation(String lat, String lng) async {
    var req = base.put
        .path(basePath)
        .path("/me/location/:lat/:lng")
        .pathParams("lat", lat)
        .pathParams("lng", lng);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> updateFcm(String token) async {
    var req = base.put
        .path(basePath)
        .path("/me/fcm/:token")
        .pathParams("token", token);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseNotifications> getNotifications(DateTime timeStamp) async {
    var req = base.get
        .path(basePath)
        .path("/me/notifications/:last_notification_time")
        .pathParams("last_notification_time", timeStamp);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> newMessage(String id) async {
    var req = base.post
        .path(basePath)
        .path("/me/newmessage/:id")
        .pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> newShare(String id) async {
    var req =
        base.post.path(basePath).path("/me/newshare/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> newForward(String id) async {
    var req = base.post
        .path(basePath)
        .path("/me/newforward/:id")
        .pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> newCall(String id) async {
    var req =
        base.post.path(basePath).path("/me/newcall/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> report(RequestReport request, String id) async {
    var req = base.post
        .path(basePath)
        .path("/report/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(request));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseContacts> getContacts() async {
    var req = base.get.path(basePath).path("/me/contacts");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseContacts> getInvites() async {
    var req = base.get.path(basePath).path("/me/invites");
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> proUser(
      AlmajlisPurchesProUserRequest proUserRequest) async {
    var req = base.post
        .path(basePath)
        .path("/me/gopro/applepay")
        .json(jsonConverter.to(proUserRequest));
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
