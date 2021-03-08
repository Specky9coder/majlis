import 'dart:convert';
import 'dart:io';
import 'package:almajlis/activities/ActivityNotification.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/activities/ActivityVideoCallOperationsScreen.dart';
import 'package:almajlis/activities/call.dart';
import 'package:almajlis/core/core.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisNotification.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/services/NavigationService.dart';
import 'package:almajlis/services/PushRegisterService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final PushRegisterService _pushRegisterService = PushRegisterService();

  Future initialise() async {
    print(_pushRegisterService.isForeground);

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
//      Foreground
        onMessage: (Map<String, dynamic> message) async {
//          _pushRegisterService.fromNotification = true;
          _pushRegisterService.message = message;
      print('onMessage: $message');
      foregroundSerializeAndNavigate(message);
    },
//        Application is closed
        onLaunch: (Map<String, dynamic> message) async {
          _pushRegisterService.fromNotification = true;
          _pushRegisterService.message = message;
      print('onLauch: $message');
      serializeAndNavigate(message);
    },
//        Background
        onResume: (Map<String, dynamic> message) async {
          _pushRegisterService.message = message;
      print('onResume: $message');
      serializeAndNavigate(message);
    });
  }

  void foregroundSerializeAndNavigate(Map<String, dynamic> message) {
    print("on foreground");
    Map<String, dynamic> data;
    if (Platform.isIOS) {
      data = message;
      if (data['type'] == "11") {
        Core().eventBus.publish(CallEndedEvent());
      }
      if (data['type'] == "5") {
        print("in status 5");
        if (null != data['booking']) {
          print("when data not null");
          var bookingData = data['booking'];
          Map<String, dynamic> temp = jsonDecode(bookingData);
          Booking booking = Booking.fromMap(temp);
          print(booking.id);
          if (null != booking.id) {
            print("in booking");
            Core()
                .getIt<NavigationService>()
                .navigateTo(ActivityVideoCallOperationsScreen(booking.id));
          }
        }
      }
    }
    else {
      if(message['data']['type'] == "11") {
        Core().eventBus.publish(CallEndedEvent());
      }
      if(message['data']['type'] == "5") {
        if(null != message['data']['booking']) {
          var bookingData = message['data']['booking'];
          Map<String, dynamic> temp = jsonDecode(bookingData);
          Booking booking = Booking.fromMap(temp);
          print(booking.id);
          if(null != booking.id) {
            Core().getIt<NavigationService>().navigateTo(
                ActivityVideoCallOperationsScreen(booking.id)
            );
          }
        }
      }
    }
    if (Platform.isIOS) {
      if (!_pushRegisterService.isForeground) {
        if (data['type'] == "1") {
          if (null != data['post']) {
            var postData = data['post'];
            Map<String, dynamic> temp = jsonDecode(postData);
            AlMajlisPost post = AlMajlisPost.fromMap(temp);
            print(post);
            if (null != post.postId) {
              Core().getIt<NavigationService>().navigateTo(ActivitySinglePost(
                    id: post.postId,
                  ));
            }
          }
        }
        if (data['type'] == "2") {
          if (null != data['comment']) {
            var commentData = data['comment'];
            Map<String, dynamic> temp = jsonDecode(commentData);
            AlMajlisComment comment = AlMajlisComment.fromMap(temp);
            print(comment.post.postId);
            if (null != comment.post.postId) {
              Core().getIt<NavigationService>().navigateTo(ActivitySinglePost(
                    id: comment.post.postId,
                  ));
            }
          }
        }
        if (data['type'] == "9") {
          if (null != data['message_by']) {
            var userData = data['message_by'];
            Map<String, dynamic> temp = jsonDecode(userData);
            User user = User.fromMap(temp);
            print(user.userId);
            if (null != user.userId) {
              Core().getIt<NavigationService>().navigateTo(ActivityUserChat(
                    myUserId: Core().getCurrentUser().userId,
                    otherPersonUserId: user.userId,
                  ));
            }
          }
        }
        if (data['type'] == "10") {
          if (null != data['forwarded_by']) {
            var userData = data['forwarded_by'];
            Map<String, dynamic> temp = jsonDecode(userData);
            User user = User.fromMap(temp);
            print(user.userId);
            if (null != user.userId) {
              Core().getIt<NavigationService>().navigateTo(ActivityProfile(
                    userId: user.userId,
                  ));
            }
          }
        }
      }
    }
  }

  void serializeAndNavigate(Map<String, dynamic> message) {
    print("in serailize and navigate");

    Map<String, dynamic> data;
    if (Platform.isIOS) {
      data = message;
      if (data['type'] == "1") {
        if (null != data['post']) {
          var postData = data['post'];
          Map<String, dynamic> temp = jsonDecode(postData);
          AlMajlisPost post = AlMajlisPost.fromMap(temp);
          print(post);
          if (null != post.postId) {
            Core().getIt<NavigationService>().navigateTo(ActivitySinglePost(
              id: post.postId,
            ));
          }
        }
      }
      if (data['type'] == "2") {
        if (null != data['comment']) {
          var commentData = data['comment'];
          Map<String, dynamic> temp = jsonDecode(commentData);
          AlMajlisComment comment = AlMajlisComment.fromMap(temp);
          print(comment.post.postId);
          if (null != comment.post.postId) {
            Core().getIt<NavigationService>().navigateTo(ActivitySinglePost(
              id: comment.post.postId,
            ));
          }
        }
      }
      if (data['type'] == "5") {
        if (null != data['booking']) {
          var bookingData = data['booking'];
          Map<String, dynamic> temp = jsonDecode(bookingData);
          Booking booking = Booking.fromMap(temp);
          print(booking.id);
          if (null != booking.id) {
            Core()
                .getIt<NavigationService>()
                .navigateTo(ActivityVideoCallOperationsScreen(booking.id));
          }
        }
      }
      if (data['type'] == "9") {
        if (null != data['message_by']) {
          var userData = data['message_by'];
          Map<String, dynamic> temp = jsonDecode(userData);
          User user = User.fromMap(temp);
          print(user.userId);
          if (null != user.userId) {
            Core().getIt<NavigationService>().navigateTo(ActivityUserChat(
              myUserId: Core().getCurrentUser().userId,
              otherPersonUserId: user.userId,
            ));
          }
        }
      }
      if (data['type'] == "10") {
        if (null != data['forwarded_by']) {
          var userData = data['forwarded_by'];
          Map<String, dynamic> temp = jsonDecode(userData);
          User user = User.fromMap(temp);
          print(user.userId);
          if (null != user.userId) {
            Core().getIt<NavigationService>().navigateTo(ActivityProfile(
              userId: user.userId,
            ));
          }
        }
      }
    }
    else {
      if(message['data']['type'] == "1") {
        if(null != message['data']['post']) {
          var postData = message['data']['post'];
          Map<String, dynamic> temp = jsonDecode(postData);
          AlMajlisPost post = AlMajlisPost.fromMap(temp);
          print(post);
          if(null != post.postId) {
            Core().getIt<NavigationService>().navigateTo(
                ActivitySinglePost(
                  id: post.postId,
                )
            );
          }
        }
      }
      if(message['data']['type'] == "2") {
        if(null != message['data']['comment']) {
          var commentData = message['data']['comment'];
          Map<String, dynamic> temp = jsonDecode(commentData);
          AlMajlisComment comment = AlMajlisComment.fromMap(temp);
          print(comment.post.postId);
          if(null != comment.post.postId) {
            Core().getIt<NavigationService>().navigateTo(
                ActivitySinglePost(
                  id: comment.post.postId,
                )
            );
          }
        }
      }
      if(message['data']['type'] == "5") {
        if(null != message['data']['booking']) {
          var bookingData = message['data']['booking'];
          Map<String, dynamic> temp = jsonDecode(bookingData);
          Booking booking = Booking.fromMap(temp);
          print(booking.id);
          if(null != booking.id) {
            Core().getIt<NavigationService>().navigateTo(
                ActivityVideoCallOperationsScreen(booking.id)
            );
          }
        }
      }
      if(message['data']['type'] == "9") {
        if(null != message['data']['message_by']) {
          var userData = message['data']['message_by'];
          Map<String, dynamic> temp = jsonDecode(userData);
          User user = User.fromMap(temp);
          print(user.userId);
          if(null != user.userId) {
            Core().getIt<NavigationService>().navigateTo(
                ActivityUserChat(
                  myUserId: Core().getCurrentUser().userId,
                  otherPersonUserId: user.userId,
                )
            );
          }
        }
      }
      if(message['data']['type'] == "10") {
        if(null != message['data']['forwarded_by']) {
          var userData = message['data']['forwarded_by'];
          Map<String, dynamic> temp = jsonDecode(userData);
          User user = User.fromMap(temp);
          print(user.userId);
          if(null != user.userId) {
            Core().getIt<NavigationService>().navigateTo(
                ActivityProfile(
                  userId: user.userId,
                )
            );
          }
        }
      }
    }



    if (null != data['type']) {
      switch (data['type']) {
        case "1":
          Core().getIt<NavigationService>().navigateTo(ActivitySinglePost(
                id: data['post']['_id'],
              ));
//          getIt<NavigationService>().navigateTo('navigation');
          break;
        case "2":
          break;
        case "3":
          break;
        case "4":
          break;
      }
    }
  }
}
