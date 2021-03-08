import 'dart:convert';
import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityEditProfile.dart';
import 'package:almajlis/activities/ActivityLogin.dart';
import 'package:almajlis/activities/ActivityNotification.dart';
import 'package:almajlis/activities/ActivityPosts.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/activities/ActivityVideoCallOperationsScreen.dart';
import 'package:almajlis/activities/ActivityWorkExperience.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/services/NavigationService.dart';
import 'package:almajlis/services/PushRegisterService.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'ActivityHomeScreens.dart';
import 'ActivitySinglePost.dart';

class ActivitySplashScreen extends StatefulWidget {
  @override
  _ActivitySplashScreenState createState() => _ActivitySplashScreenState();
}

class _ActivitySplashScreenState
    extends ActivityStateBase<ActivitySplashScreen> {
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = core.isUserLoggedIn();

    if (null == core.getCurrentUser() ||
        core.getCurrentUser().firstName == "" ||
        core.getCurrentUser().firstName == null) {
      isUserLoggedIn = false;
    }

    Future.delayed(Duration(seconds: 2), () {
      print('\n\n\n');
      print(core.getCurrentUser());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              core.isUserLoggedIn() ? Home() : ActivityPosts()));
      print('\n\n\n');

      // MaterialPageRoute(builder: (context) => ActivityPosts()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlMajlisBackground(Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.asset("drawables/almajlis_appicon.png", height: 100),
          ),
        ],
      ),
    ));
  }

  @override
  onWidgetInitialized() {
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => ActivityPosts()),
    //     (Route<dynamic> route) => false);
    // Future.delayed(
    //     Duration(seconds: 2),
    //         () {
    //           print(core.getCurrentUser());
    //         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ActivityPosts()), (Route<dynamic> route) => false);
    //     }
    // );
  }
}
