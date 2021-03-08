import 'dart:async';
import 'package:almajlis/core/core.dart';
import 'package:almajlis/core/server/ApiBooking.dart';
import 'package:almajlis/core/server/ApiDiscover.dart';
import 'package:almajlis/core/server/ApiPosts.dart';
import 'package:almajlis/core/server/ApiUsers.dart';
import 'package:almajlis/core/server/ApiUtils.dart';
import 'package:almajlis/core/server/wrappers/RequestLogin.dart';
import 'package:almajlis/core/server/wrappers/RequestReport.dart';
import 'package:almajlis/core/server/wrappers/ResponseAvailableTimeSlots.dart';
import 'package:almajlis/core/server/wrappers/ResponseBooking.dart';
import 'package:almajlis/core/server/wrappers/ResponseBookings.dart';
import 'package:almajlis/core/server/wrappers/ResponseComments.dart';
import 'package:almajlis/core/server/wrappers/ResponseContacts.dart';
import 'package:almajlis/core/server/wrappers/ResponseLogin.dart';
import 'package:almajlis/core/server/wrappers/ResponseNotifications.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/server/wrappers/ResponsePost.dart';
import 'package:almajlis/core/server/wrappers/ResponsePosts.dart';
import 'package:almajlis/core/server/wrappers/ResponseSearchPost.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/AlmajlisPurchesProUserRequest.dart';
import 'package:almajlis/core/wrappers/User.dart';

import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:http/io_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'ApiAuth.dart';

class Server {
  // Create references for all the API interface files
  ApiAuth _apiAuth;
  ApiUsers _apiUsers;
  ApiPosts _apiPosts;
  ApiBooking _apiBooking;
  ApiDiscover _apiDiscover;
  ApiUtils _apiUtils;

//  Home Server
//  static final  String BASE_URL = "http://192.168.43.147:3000";
//    static final  String BASE_URL = "http://192.168.1.117:3000";
//  static final  String BASE_URL = "http://35.162.45.246:3000";
  static final String BASE_URL =
      "http://almajlis-node-balancer-1746838909.me-south-1.elb.amazonaws.com";

  //Prod server
//  static final  String BASE_URL = "";

  Server(SessionInterface sessionInterface) {
    globalClient = IOClient();

    final repo = JsonRepo()
      ..add(ResponseOkSerializer())
      ..add(UserSerializer())
      ..add(AlMajlisPostSerializer())
      ..add(RequestLoginSerializer())
      ..add(RequestReportSerializer())
      ..add(AlMajlisCommentSerializer())
      ..add(ResponseLoginSerializer())
      ..add(ResponseUserSerializer())
      ..add(ResponseOkSerializer())
      ..add(ResponsePostSerializer())
      ..add(ResponsePostsSerializer())
      ..add(ResponseSignedUrlSerializer())
      ..add(ResponseUsersSerializer())
      ..add(ResponseCommentsSerializer())
      ..add(ResponsePaymentSuccessSerializer())
      ..add(ResponseBookingsSerializer())
      ..add(ResponseUtilsSerializer())
      ..add(ResponseNotificationsSerializer())
      ..add(ResponseAvailableTimeSlotsSerializer())
      ..add(ResponseBookingSerializer())
      ..add(ResponseContactsSerializer())
      ..add(LoginPayloadSerializer())
      ..add(ResponseSearchPostSerializer())
      ..add(AlmajlisPurchesProUserRequestSerializer());
    // Include all serializers in repo

    _apiAuth = ApiAuth(route(BASE_URL), sessionInterface)..jsonConverter = repo;
    _apiUsers = ApiUsers(route(BASE_URL), sessionInterface)
      ..jsonConverter = repo;
    _apiPosts = ApiPosts(route(BASE_URL), sessionInterface)
      ..jsonConverter = repo;
    _apiBooking = ApiBooking(route(BASE_URL), sessionInterface)
      ..jsonConverter = repo;
    _apiDiscover = ApiDiscover(route(BASE_URL), sessionInterface)
      ..jsonConverter = repo;
    _apiUtils = ApiUtils(route(BASE_URL), sessionInterface)
      ..jsonConverter = repo;
  }

  /** Login API
   * params: token
   * returns ResponseLogin
   **/
  Future<ResponseLogin> userLogin(String fcmId) async {
    RequestLogin request = RequestLogin();
    request.fcmId = fcmId;
    ResponseLogin response = await _apiAuth.userLogin(request);
    return response;
  }

//  User Operations

//  Self
  Future<ResponseUser> getUser({String id}) async {
    ResponseUser response;

    if (null != id) {
      response = await _apiUsers.getUserProfile(id);
    } else
      response = await _apiUsers.getUser();

    return response;
  }

  Future<ResponseOk> editUser(User user) async {
    ResponseOk response = await _apiUsers.editUser(user);
    return response;
  }

  Future<ResponsePaymentSuccess> goPro() async {
    ResponsePaymentSuccess response = await _apiUsers.goPro();
    return response;
  }

  Future<ResponseOk> proUser(
      AlmajlisPurchesProUserRequest proUserRequest) async {
    ResponseOk response = await _apiUsers.proUser(proUserRequest);
    return response;
  }

//  Other User

  Future<ResponseOk> addConnection(String id) async {
    ResponseOk response = await _apiUsers.addConnection(id);
    return response;
  }

  Future<ResponseOk> removeConnection(String id) async {
    ResponseOk response = await _apiUsers.removeConnection(id);
    return response;
  }

  Future<ResponseUsers> searchUsers(String query, int offset) async {
    ResponseUsers response = await _apiUsers.searchUsers(query, offset);
    return response;
  }

  Future<ResponseSearchPost> searchPosts(String query, int offset) async {
    ResponseSearchPost response = await _apiPosts.searchPosts(query, offset);
    return response;
  }

  Future<ResponsePosts> getUserPosts(String userid) async {
    ResponsePosts response = await _apiPosts.getUserPosts(userid);
    return response;
  }

//  Comment operations

  Future<ResponseComments> getComments(String id, int offset) async {
    ResponseComments response = await _apiPosts.getComments(id, offset);
    return response;
  }

  Future<ResponseOk> likeComment(String id) async {
    ResponseOk response = await _apiPosts.likeComment(id);
    return response;
  }

  Future<ResponseOk> dislikeComment(String id) async {
    ResponseOk response = await _apiPosts.dislikeComment(id);
    return response;
  }

  Future<ResponseOk> addComment(AlMajlisComment comment, String id) async {
    ResponseOk response = await _apiPosts.addComment(comment, id);
    return response;
  }

  Future<ResponseOk> editComment(AlMajlisComment comment, String id) async {
    ResponseOk response = await _apiPosts.editComment(comment, id);
    return response;
  }

  Future<ResponseOk> deleteComment(String id) async {
    ResponseOk response = await _apiPosts.deleteComment(id);
    return response;
  }

//  bookings operation

  Future<ResponsePaymentSuccess> bookMeeting(String id, DateTime date) async {
    ResponsePaymentSuccess response = await _apiBooking.bookMeeting(id, date);
    return response;
  }

  Future<ResponseAvailableTimeSlots> getAvailableTimeSlots(
      String id, DateTime date) async {
    ResponseAvailableTimeSlots response =
        await _apiBooking.getAvailableTimeSlots(id, date);
    return response;
  }

  Future<ResponseBookings> getBookings() async {
    ResponseBookings response = await _apiUsers.getGreetings();
    return response;
  }

  Future<ResponseBookings> getMeetings() async {
    ResponseBookings response = await _apiUsers.getMeetings();
    print('\n\n\n');
    print(response);
    print('\n\n\n');

    return response;
  }

  Future<ResponseOk> startBooking(String id) async {
    ResponseOk response = await _apiBooking.startBooking(id);
    return response;
  }

  Future<ResponseOk> leftBooking(String id) async {
    ResponseOk response = await _apiBooking.leftBooking(id);
    return response;
  }

  Future<ResponseOk> declineBooking(String id) async {
    ResponseOk response = await _apiBooking.declineBooking(id);
    return response;
  }

  Future<ResponseBooking> getBookingDetails(String id) async {
    ResponseBooking response = await _apiBooking.getBookingDetails(id);
    return response;
  }

// Post Operations

  Future<ResponseOk> addPost(AlMajlisPost post) async {
    ResponseOk response = await _apiPosts.addPost(post);
    return response;
  }

  Future<ResponsePosts> getPosts(DateTime timestamp, String country,
      bool prousers, distance, lat, lng) async {
    print("lat++++++++++++++++++++=");
    print(lat);
    print("lng++++++++++++++++++++++");
    print(lng);
    ResponsePosts response = await _apiPosts.getPosts(
        timestamp, country, prousers, distance, lat, lng);
    return response;
  }

  Future<ResponsePost> getPostDetails(String id) async {
    print("in server" + id);
    ResponsePost response = await _apiPosts.getPostDetails(id);
    return response;
  }

  Future<ResponseOk> editPost(AlMajlisPost post) async {
    ResponseOk response = await _apiPosts.editPost(post.postId, post);
    return response;
  }

  Future<ResponseOk> deletePost(String id) async {
    ResponseOk response = await _apiPosts.deletePost(id);
    return response;
  }

  Future<ResponseSignedUrl> getSignedUrl(String extension) async {
    ResponseSignedUrl response = await _apiPosts.getSignedUrl(extension);
    return response;
  }

  Future<ResponseOk> likePost(String id) async {
    ResponseOk response = await _apiPosts.likePost(id);
    return response;
  }

  Future<ResponseOk> dislikePost(String id) async {
    ResponseOk response = await _apiPosts.dislikePost(id);
    return response;
  }

//  General

  Future<ResponseOk> updateLocation(String lat, String lng) async {
    print("lat" + lat.toString() + "lng" + lng.toString());
    ResponseOk response = await _apiUsers.updateLocation(lat, lng);
    return response;
  }

  Future<ResponseOk> updateFcm(String token) async {
    ResponseOk response = await _apiUsers.updateFcm(token);
    return response;
  }

  Future<ResponseUsers> getUsersForDiscover(String lat, String lng,
      String distance, String country, bool prousers, int offset) async {
    print("in server");
    ResponseUsers response = await _apiDiscover.getUserForDiscover(
        lat, lng, distance, country, prousers, offset);
    print(response);
    return response;
  }

  Future<ResponseUsers> getNearMeUsers(String lat, String lng) async {
    print("in server");
    ResponseUsers response = await _apiDiscover.getUsersNearMe(lat, lng);
    print(response);
    return response;
  }

  Future<ResponseNotifications> getNotifications(DateTime timestamp) async {
    ResponseNotifications response =
        await _apiUsers.getNotifications(timestamp);
    return response;
  }

  Future<ResponseOk> reportPost(String id, String reportReason) async {
    RequestReport request = RequestReport();
    request.report = reportReason;
    ResponseOk response = await _apiPosts.report(request, id);
    return response;
  }

  Future<ResponseOk> reportComment(String id, String reportReason) async {
    RequestReport request = RequestReport();
    request.report = reportReason;
    ResponseOk response = await _apiPosts.reportComment(request, id);
    return response;
  }

  Future<ResponseOk> reportUser(String id, String reportReason) async {
    RequestReport request = RequestReport();
    request.report = reportReason;
    ResponseOk response = await _apiUsers.report(request, id);
    return response;
  }

  Future<ResponseOk> newMessage(String id) async {
    ResponseOk response = await _apiUsers.newMessage(id);
    return response;
  }

  Future<ResponseOk> newShare(String id) async {
    ResponseOk response = await _apiUsers.newShare(id);
    return response;
  }

  Future<ResponseOk> newForward(String id) async {
    ResponseOk response = await _apiUsers.newForward(id);
    return response;
  }

  Future<ResponseOk> newCall(String id) async {
    ResponseOk response = await _apiUsers.newCall(id);
    return response;
  }

  Future<ResponseContacts> getContacts() async {
    ResponseContacts response = await _apiUsers.getContacts();
    return response;
  }

  Future<ResponseContacts> getInvites() async {
    ResponseContacts response = await _apiUsers.getInvites();
    return response;
  }

//  Utils
  Future<ResponseUtils> getUtils() async {
    ResponseUtils response = await _apiUtils.getUtils();
    return response;
  }
}

class GenericRequestInterceptor extends ApiClient {
  final resty.Route base;
  SessionInterface _sessionInterface;

  GenericRequestInterceptor(this.base, this._sessionInterface) {
    base.before(_setAuthHeader());

    // Add response logger only in debug mode
    assert(() {
      base.after(_responseInterceptor);
      return true;
    }());
  }

  resty.Before _setAuthHeader() => (resty.RouteBase route) {
        String token = _sessionInterface.getToken();
        if (null != token && !token.isEmpty) {
          route.header("authorization", "Bearer " + token);
        }
      };

  @override
  FutureOr _responseInterceptor(StringResponse response) {
    print("========= START RESPONSE =======");
    print("URL : " + response.request.url.toString());
    print("Response Body : ");
    print(response.body);
    print("========= END RESPONSE =========");
    return response;
  }
}
