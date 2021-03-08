import 'package:almajlis/activities/ActivityPosts.dart';
import 'package:almajlis/core/server/Server.dart';
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
import 'package:almajlis/services/PushNotificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_event_bus/flutter_event_bus/EventBus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/StringConstants.dart';

class Core implements SessionInterface {
  SharedPreferences _prefs = null;
  User _currentUser = null;
  String _lastFCMToken;
  String _token = null;
  StringConstants stringConstants = new StringConstants();
  PushNotificationService _pushNotificationService = PushNotificationService();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging()
    ..setAutoInitEnabled(true);
  Server _server;
  bool isInitialized = false;
  bool isFirstTimeOnProducts = false;
  var _onInitComplete;
  BuildContext context;
  final getIt = GetIt.instance;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final eventBus = EventBus();
  static Core _instance;

  factory Core({onInitComplete}) {
    if (null == _instance) {
      _instance = Core._internal(onInitComplete);
    }
    print("core initialized");
    return _instance;
  }

  Core._internal(onInitComplete) {
    if (null != onInitComplete) {
      print("-------- onInitComplete initialized");
      _onInitComplete = onInitComplete;
    } else {
      print("-------- onInitComplete is null");
    }
    _initServices();
    _firebaseMessaging.onTokenRefresh.listen((String newToken) {
      updateFCMToken(token: newToken);
    });
  }

  void _initServices() async {
    _prefs = await SharedPreferences.getInstance();
    _server = Server(this);
    await _pushNotificationService.initialise();
//    getIt.registerLazySingleton(() => NavigationService());
    _getSession();
  }

  User getCurrentUser() {
    return _currentUser;
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    this._storeSession(getToken(), user);
  }

  void setCountryName(String countryName) {
    _prefs.setString("countryName", countryName);
  }

  String getCountryName() {
    return _prefs.getString("countryName");
  }

  void updateSession(String token, User user) {
//      if(null == _token && null == _currentUser) {
    _storeSession(token, user);
    return;
//      }
//      throw Error();
  }

  void _storeSession(String token, User user) async {
    _currentUser = user;
    _token = token;
    if (null != user.firstName && !user.firstName.isEmpty)
      _prefs.setString("firstName", user.firstName);
    if (null != user.lastName && !user.lastName.isEmpty)
      _prefs.setString("lastName", user.lastName);
    if (null != user.companyName && !user.companyName.isEmpty)
      _prefs.setString("companyName", user.companyName);
    _prefs.setString("id", user.userId);
    _prefs.setString("fcm_token", user.fcmToken);
    _prefs.setString("token", token);
  }

  void _getSession() async {
    _token = await _prefs.getString("token");
    User currentUser = User();
    currentUser.firstName = _prefs.getString("firstName");
    currentUser.lastName = _prefs.getString("lastName");
    currentUser.userId = _prefs.getString("id");
    currentUser.companyName = _prefs.getString("companyName");
    _currentUser = currentUser;
    _lastFCMToken = await _prefs.getString("fcm_token");
    isInitialized = true;
    if (null != _onInitComplete) {
      _onInitComplete();
    }
  }

  void updateFCMToken({String token}) async {
    if (null == token) {
      token = await _firebaseMessaging.getToken();
    }
    if (isUserLoggedIn()) _server.updateFcm(token);
//    if(token != _lastFCMToken) {
//      _lastFCMToken = token;
//
//    }
  }

  logout(BuildContext context) async {
    _prefs.remove("firstName");
    _prefs.remove("lastName");
    _prefs.remove("id");
    _prefs.remove("token");
    _prefs.remove("companyName");
    _token = null;
    _currentUser = null;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ActivityPosts()),
        (Route<dynamic> route) => false);
  }

  @override
  String getToken() {
    return _token;
  }

  bool isUserLoggedIn() {
    return null != _token &&
        null != _currentUser.firstName &&
        !_currentUser.firstName.isEmpty;
  }

  // Return TRUE if server responded with error
  bool systemCanHandel(var response, {BuildContext context, String from}) {
    try {
      if (null == response) {
        Fluttertoast.showToast(
            msg: StringConstants.COULD_NOT_CONNECT_TO_SERVER,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Server error. Please try again in some time",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      throw e;
    }
  }

  void startLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.all(16),
            backgroundColor: Colors.transparent,
            content: Builder(
              builder: (context) {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      color: Colors.white,
                    ),
//                  child: Center(
//                    child: Loading(
//                        indicator: BallPulseIndicator(),
//                        size: 20.0,
//                        color: Constants.COLOR_PRIMARY_TEAL
//                    ),
//                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  void stopLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<ResponseLogin> userLogin(String fcmId) {
    return _server.userLogin(fcmId);
  }

//  User operations
//  Self

  Future<ResponseOk> editUser(User user) {
    return _server.editUser(user);
  }

  Future<ResponseUser> getUser({String id}) {
    if (null != id) {
      return _server.getUser(id: id);
    } else
      return _server.getUser();
  }

  Future<ResponsePaymentSuccess> goPro() {
    return _server.goPro();
  }

  Future<ResponseOk> proUser(AlmajlisPurchesProUserRequest proUserRequest) {
    return _server.proUser(proUserRequest);
  }

//  Other User

  Future<ResponseOk> addConnection(String id) {
    return _server.addConnection(id);
  }

  Future<ResponseOk> removeConnection(String id) {
    return _server.removeConnection(id);
  }

  Future<ResponseUsers> searchUsers(String query, int offset) {
    return _server.searchUsers(query, offset);
  }

// Post Operations

  Future<ResponseOk> addPost(AlMajlisPost post) {
    return _server.addPost(post);
  }

  Future<ResponsePosts> getPosts(
      DateTime timestamp, String country, bool prousers, distance, lat, lng) {
    print("lat++++++++++++++++++++=");
    print(lat);
    print("lng++++++++++++++++++++++");
    print(lng);
    return _server.getPosts(timestamp, country, prousers, distance, lat, lng);
  }

  Future<ResponsePosts> getUserPosts(String userId) {
    return _server.getUserPosts(userId);
  }

  Future<ResponsePost> getPostDetails(String id) {
    return _server.getPostDetails(id);
  }

  Future<ResponseOk> editPost(AlMajlisPost post) {
    return _server.editPost(post);
  }

  Future<ResponseSearchPost> searchPosts(String query, int offset) {
    return _server.searchPosts(query, offset);
  }

  Future<ResponseAvailableTimeSlots> getAvailabelSlots(
      String id, DateTime date) async {
    return _server.getAvailableTimeSlots(id, date);
  }

  Future<ResponseOk> deletePost(String id) {
    return _server.deletePost(id);
  }

  Future<ResponseSignedUrl> getSignedUrl(String extension) {
    return _server.getSignedUrl(extension);
  }

  Future<ResponseComments> getComments(String id, int offset) {
    return _server.getComments(id, offset);
  }

  Future<ResponseOk> addComment(AlMajlisComment comment, String id) {
    return _server.addComment(comment, id);
  }

  Future<ResponseOk> editComment(AlMajlisComment comment, String id) {
    return _server.editComment(comment, id);
  }

  Future<ResponseOk> deleteComment(String id) {
    return _server.deleteComment(id);
  }

  Future<ResponsePaymentSuccess> bookMeeting(String id, DateTime date) async {
    return _server.bookMeeting(id, date);
  }

  Future<ResponseBookings> getBookings() async {
    return _server.getBookings();
  }

  Future<ResponseBookings> getMeetings() async {
    return _server.getMeetings();
  }

  Future<ResponseOk> startBooking(String id) async {
    return _server.startBooking(id);
  }

  Future<ResponseOk> leftBooking(String id) async {
    return _server.leftBooking(id);
  }

  Future<ResponseOk> declineBooking(String id) async {
    return _server.declineBooking(id);
  }

  Future<ResponseBooking> getBookingDetails(String id) async {
    return _server.getBookingDetails(id);
  }

  Future<ResponseOk> updateLocation(String lat, String lng) async {
    print("lat" + lat.toString() + "lng" + lng.toString());
    return _server.updateLocation(lat, lng);
  }

  Future<ResponseOk> likePost(String id) async {
    return _server.likePost(id);
  }

  Future<ResponseOk> dislikePost(String id) {
    return _server.dislikePost(id);
  }

  Future<ResponseOk> likeComment(String id) {
    return _server.likeComment(id);
  }

  Future<ResponseOk> dislikeComment(String id) {
    return _server.dislikeComment(id);
  }

  Future<ResponseUsers> getUsersForDiscover(String lat, String lng,
      String distance, String country, bool prousers, int offset) {
    return _server.getUsersForDiscover(
        lat, lng, distance, country, prousers, offset);
  }

  Future<ResponseUsers> getNearMeUsers(String lat, String lng) {
    return _server.getNearMeUsers(lat, lng);
  }

  Future<ResponseOk> reportPost(String id, String reportReason) {
    return _server.reportPost(id, reportReason);
  }

  Future<ResponseOk> reportComment(String id, String reportReason) {
    return _server.reportComment(id, reportReason);
  }

  Future<ResponseOk> reportUser(String id, String reportReason) {
    return _server.reportUser(id, reportReason);
  }

  Future<ResponseOk> newMessage(String id) {
    return _server.newMessage(id);
  }

  Future<ResponseOk> newShare(String id) {
    return _server.newShare(id);
  }

  Future<ResponseOk> newForward(String id) {
    return _server.newForward(id);
  }

  Future<ResponseOk> newCall(String id) {
    return _server.newCall(id);
  }

  Future<ResponseOk> updateFcm(String token) {
    return _server.updateFcm(token);
  }

  Future<ResponseNotifications> getNotifications(DateTime timestamp) async {
    return _server.getNotifications(timestamp);
  }

  Future<ResponseUtils> getUtils() {
    return _server.getUtils();
  }

  Future<ResponseContacts> getContacts() async {
    return _server.getContacts();
  }

  Future<ResponseContacts> getInvites() async {
    return _server.getInvites();
  }
}

class SessionInterface {
  String getToken() {}
}
