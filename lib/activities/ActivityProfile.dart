import 'dart:io';
import 'dart:ui';

import 'package:almajlis/activities/ActivityAddNewPost.dart';
import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityBookings.dart';
import 'package:almajlis/activities/ActivityContact.dart';
import 'package:almajlis/activities/ActivityCreditCardPayment.dart';
import 'package:almajlis/activities/ActivityEditProfile.dart';
import 'package:almajlis/activities/ActivityEducation.dart';
import 'package:almajlis/activities/ActivityGoPro.dart';
import 'package:almajlis/activities/ActivityMyMeetings.dart';
import 'package:almajlis/activities/ActivitySettings.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/activities/ActivityUserChatList.dart';
import 'package:almajlis/activities/ActivityViewTotalPost.dart';
import 'package:almajlis/activities/ActivityWorkExperience.dart';
import 'package:almajlis/core/server/wrappers/ResponseAvailableTimeSlots.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePosts.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';
import 'package:almajlis/core/wrappers/AlMajlisBooking.dart';
import 'package:almajlis/core/wrappers/AlMajlisEducation.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/BottomSheetProfile.dart';
import 'package:almajlis/views/bottomsheets/PostShareBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';
import 'package:almajlis/views/components/AlMajlisCountCard.dart';
import 'package:almajlis/views/components/AlMajlisDateCard.dart';
import 'package:almajlis/views/components/AlMajlisExperienceCard.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlMajlisLinkText.dart';
import 'package:almajlis/views/components/AlMajlisNavigationBar.dart';
import 'package:almajlis/views/components/AlMajlisRadioButton.dart';
import 'package:almajlis/views/components/AlMajlisShortPostCard.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/dialogs/DialogAvailableTimeSlot.dart';
import 'package:almajlis/views/dialogs/DialogReport.dart';
import 'package:almajlis/views/widgets/AlMajlisDatePicker.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

//TODO: @Aditya @Shreya Check crash while removing experience in profile

class ActivityProfile extends StatefulWidget {
  String userId;
  ActivityProfile({this.userId});
  @override
  _ActivityProfileState createState() => _ActivityProfileState();
}

class _ActivityProfileState extends ActivityStateBase<ActivityProfile> {
  bool activityClosed = true;
  bool selfProfile = false;
  bool hasPro = false;
  bool showDelete = false;
  bool isAdded = false;
  bool hasBooked = false;
  bool isPublic = false;
  bool openAddNewSkill = false;
  bool openBookingSheet = false;
  User user;
  bool isMute = false;

  int metttingMinutes = 60;
  TextEditingController mettingTimeController = TextEditingController();
  final _chatsInstance = Firestore.instance.collection("chats");
  final _usersInstance = Firestore.instance.collection("users");

  String userName = "";
  String occupation = "";
  String bio = "";
  String companyName = "";
  String startDate = "";
  String endDate = "";
  String workPeriod = "";
  String educationPeriod = "";
  String link = "";
  String userSince = "";
  String updatedAt = "";
  BuildContext _context;
  String imageLink = "";
  String videoLink = "";
  String country = "";
  String phoneNumber = "";
  bool image = true;
  int progress = 0;
  int postCount = 0;
  int contactCount = 0;
  int messageCount = 0;
  int replyCount = 0;
  int likeCount = 0;
  int forwardCount = 0;
  int shareCount = 0;
  int inviteCount = 0;
  int callCount = 0;
  int profileViews = 0;
  num meetingCharges = 0;
  num serviceCharge = 0.0;
  num totalCharges = 0.0;
  num proCharges = 0;
  int bookingLeft = 0;
  int bookingRight = 0;
  String timezoneName = "";

  final scaffoldState = GlobalKey<ScaffoldState>();
  VideoPlayerController _controller;
  ScrollController skillController = ScrollController();
  TextEditingController interestController = TextEditingController();
  List<RadioModel> radioBtnData = new List<RadioModel>();
  AlMajlisEducation education;
  List<String> skillsAndExperiences = List();
  List<AlMajlisPost> posts = List();
  DateTime bookingDate;
  bool showSkils = false;
  var videoThumb;
  @override
  void initState() {
    // TODO: implement initState
    radioBtnData.add(new RadioModel(true, 'Credit/Debit/AMEX'));
  }

  @override
  void dispose() {
    super.dispose();
    print("on dispose");
    if (null != _controller) _controller.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactivate");
    if (null != _controller) {
      try {
        // _controller.dispose();
      } catch (e) {}
    }
  }

  bookMeeting() async {
    bool hasError = false;
    if (null == bookingDate) {
      hasError = true;
    }

    if (!hasError) {
      AlMajlisBooking booking = AlMajlisBooking()
        ..bookingDate = bookingDate
        ..userThumb = user.thumbUrl
        ..userName = user.firstName + " " + user.lastName
        ..bookingTitle = user.callTitle
        ..paymentMethod = 0
        ..userId = user.userId;

      var data = await Navigator.of(_context).push(MaterialPageRoute(
          builder: (context) => ActivityCreditCardPayment(
                totalCharges,
                isBooking: true,
                booking: booking,
              )));

      print(data);
      if (data != null) {
        if (data) {
          setState(() {
            openBookingSheet = false;
          });
        }
        Fluttertoast.showToast(
            msg: data ? "Payment Success" : "Payment Failure",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
//        showDialog(
//            context: _context,
//            builder: (BuildContext context) {
//              return DialogSuccessFailure(data ? "Payment Success" : "Payment Failure");
//            });
      }
    }
  }

  void showForwardBottomSheet() {
    scaffoldState.currentState
        .showBottomSheet((context) => PostShareBottomSheet(
              sahreToUsers: shareToUsers,
              showCopyAndShare: false,
            ));
    newForward(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    if (null != skillsAndExperiences && skillsAndExperiences.length > 0) {
      showSkils = true;
    } else {
      showSkils = false;
    }
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        body: Container(
          color: Colors.black,
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.85,
                        child:
                            null != _controller && _controller.value.initialized
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  )
                                : null != videoThumb && !videoThumb.isEmpty
                                    ? Container(
                                        child: CachedNetworkImage(
                                          imageUrl: videoThumb,
                                          imageBuilder: (context, provider) {
                                            return Image(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.85,
                                              fit: BoxFit.cover,
                                              image: provider,
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return Container();
                                          },
                                          placeholder: (context, url) =>
                                              Container(),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                          Colors.purple,
                                          Colors.teal
                                        ])),
                                        child: Center(
                                          child: AlMajlisTextViewBold(
                                            "No Short Video Uploaded",
                                            size: 16,
                                          ),
                                        ),
                                      ),
                      ),
                      onTap: () {
                        setState(() {
                          if (null != _controller &&
                              _controller.value.initialized) {
                            _controller.pause();
                          }
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        selfProfile
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Image.asset(
                                        "drawables/Settings btn.png",
                                        height: 32,
                                      ),
                                      onTap: () {
                                        if (null != _controller &&
                                            _controller.value.initialized) {
                                          try {
                                            _controller.pause();
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivitySettings()));
                                      },
                                    ),
                                    GestureDetector(
                                      child: Image.asset(
                                        "drawables/Edit profile.png",
                                        height: 32,
                                      ),
                                      onTap: navigateToEditProfile,
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AlMajlisBackButton(
                                      onClick: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    !isAdded
                                        ? Container(
                                            width: 100,
                                            child: AlMajlisButton(
                                              "ADD",
                                              Constants.TEAL,
                                              () {
                                                addConnection();
                                              },
                                              icon: Image.asset(
                                                "drawables/add contacts.png",
                                                height: 20,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 8.0),
                                            width: 100,
                                            child: AlMajlisButton(
                                              "ADDED",
                                              4,
                                              () {
                                                removeConnection();
                                              },
                                              icon: Image.asset(
                                                "drawables/action-01.png",
                                                height: 18,
                                              ),
                                              isFromProfile: true,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.5),
                          child: Column(
                            children: <Widget>[
                              null != _controller &&
                                      _controller.value.initialized &&
                                      image
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (null != _controller &&
                                                    _controller
                                                        .value.initialized) {
                                                  try {
                                                    _controller.play();
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                }
                                              },
                                              child: Image.asset(
                                                  "drawables/ic_play_circle_outline_white_36dp.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (null != _controller &&
                                                    _controller
                                                        .value.initialized) {
                                                  try {
                                                    _controller.pause();
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                }
                                              },
                                              child: Image.asset(
                                                  "drawables/ic_pause_circle_outline_white_36dp.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (null != _controller &&
                                                    _controller
                                                        .value.initialized) {
                                                  setState(() {
                                                    isMute = !isMute;
                                                  });
                                                  _controller.setVolume(
                                                      isMute ? 0.0 : 1.0);
                                                }
                                              },
                                              child: Image.asset(isMute
                                                  ? "drawables/ic_volume_variant_off_white_36dp.png"
                                                  : "drawables/ic_volume_high_white_36dp.png")),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AlMajlisTextViewBold(
                                    userName,
                                    size: 24,
                                  ),

//                                  Icon(
//                                    Icons.done,
//                                    color: Colors.teal,
//                                    size: 24,
//                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Image.asset(
                                            "drawables/work.png",
                                            height: 16,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: occupation,
                                        style: TextStyle(
                                          fontFamily: 'ProximaNovaMedium',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Image.asset(
                                            "drawables/Add_location.png",
                                            height: 16,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: country,
                                        style: TextStyle(
                                          fontFamily: 'ProximaNovaMedium',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                        selfProfile
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: AlMajlisButton(
                                        "NEW POST",
                                        Constants.TRANS,
                                        () {
                                          if (null != _controller &&
                                              _controller.value.initialized) {
                                            try {
                                              _controller.pause();
                                            } catch (e) {
                                              print(e);
                                            }
                                          }
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityAddNewPost()));
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    hasPro
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: AlMajlisButton(
                                                "MY BOOKINGS",
                                                Constants.TEAL,
                                                () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActivityMyMeetings()));
//                                                showDialog(
//                                                    context: _context,
//                                                    builder: (BuildContext context) {
//                                                      return DialogSuccessFailure(true);
//                                                    });
                                                },
                                                icon: AlMajlisImageIcons(
                                                  "drawables/go_pro.png",
                                                  iconHeight: 24,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: AlMajlisButton(
                                                "GO PRO",
                                                Constants.TEAL,
                                                () async {
                                                  if (null != _controller &&
                                                      _controller
                                                          .value.initialized) {
                                                    try {
                                                      _controller.pause();
                                                    } catch (e) {}
                                                  }
                                                  var data = await Navigator.of(
                                                          context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActivityGoPro(
                                                                  user)));

                                                  print(
                                                      "data+++++++++++++++++++++" +
                                                          data.toString());
                                                  if (data != null) {
                                                    if (data) {
                                                      getUser();
                                                    }
                                                    Fluttertoast.showToast(
                                                        msg: data
                                                            ? "Payment Success"
                                                            : "Payment Failure",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 2);
//                                                    showDialog(
//                                                        context: _context,
//                                                        builder: (BuildContext context) {
//                                                          return DialogSuccessFailure(data ? "Payment Success" : "Payment Failure");
//                                                        });
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    !hasPro
                                        ? isPublic
                                            ? Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: AlMajlisButton(
                                                    "CALL",
                                                    Constants.TRANS,
                                                    () {
                                                      launch(
                                                          "tel:" + phoneNumber);
                                                      newCall(widget.userId);
                                                    },
                                                    icon: Icon(
                                                      Icons.call,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: AlMajlisButton(
                                                "BOOK " +
                                                    meetingCharges.toString() +
                                                    " BD",
                                                Constants.TEAL,
                                                () {
                                                  if (null != user.availabilityDays &&
                                                      null !=
                                                          user
                                                              .availabilityStart &&
                                                      user.availabilityStart >
                                                          0 &&
                                                      null !=
                                                          user
                                                              .availabilityEnd &&
                                                      user.availabilityEnd >
                                                          0) {
                                                    setState(() {
                                                      openBookingSheet = true;
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: userName +
                                                            " has not yet given availability",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 2);
//                                                    showDialog(
//                                                        context: _context,
//                                                        builder: (BuildContext context) {
//                                                          return DialogSuccessFailure("No Slots Available");
//                                                        });
                                                  }
                                                },
                                                icon: Image.asset(
                                                    "drawables/updates.png",
                                                    height: 24),
                                              ),
                                            ),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: AlMajlisButton(
                                          "MESSAGE",
                                          Constants.TRANS,
                                          () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityUserChat(
                                                          myUserId: core
                                                              .getCurrentUser()
                                                              .userId,
                                                          otherPersonUserId:
                                                              widget.userId,
                                                        )));
                                          },
                                          icon: Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AlMajlisButton(
                                      null,
                                      Constants.TRANS,
                                      () {
                                        scaffoldState.currentState
                                            .showBottomSheet(
                                                (context) => BottomSheetProfile(
                                                      reportUser: reportClicked,
                                                      shareProfile: copyLink,
                                                      forwardProfile:
                                                          showForwardBottomSheet,
                                                    ));
                                      },
                                      icon: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                      20.0) //         <--- border radius here
                                  ),
                              color: Constants.COLOR_DARK_GREY,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      null != imageLink && !imageLink.isEmpty
                                          ? AlMajlisProfileImageWithStatus(
                                              imageLink,
                                              50.0,
                                              isPro: hasPro,
                                            )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: hasPro
                                                      ? Constants
                                                          .COLOR_PRIMARY_TEAL
                                                      : Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.purple,
                                                            Colors.teal
                                                          ])),
                                                ),
                                              ),
                                            ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: bookingLeft.toString(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'ProximaNovaBold',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: ' / ' +
                                                          bookingRight
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ProximaNovaMedium',
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ]),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: AlMajlisTextViewSemiBold(
                                                  "MEETINGS"),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            AlMajlisTextViewSemiBold(
                                              profileViews.toString(),
                                              size: 24,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: AlMajlisTextViewSemiBold(
                                                  "VIEWS"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: AlMajlisTextViewMedium(
                                            bio,
                                            size: 12,
                                            maxLines: 6,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  null != link && !link.isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.link,
                                                color: Colors.teal,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: AlMajlisLinkText(link),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: selfProfile,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 20, right: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AlMajlisTextViewBold(
                                      "Profile Completion",
                                      size: 12,
                                    ),
                                    AlMajlisTextViewBold(
                                      (progress * 10).toString() + "%",
                                      size: 12,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //         <--- border radius here
                                          ),
                                    ),
                                    child: GradientProgressIndicator(
                                      gradient: LinearGradient(
                                          colors: [Colors.purple, Colors.teal]),
                                      value: progress / 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              AlMajlisTextViewBold(
                                "Activity",
                                size: 24,
                              ),
                              activityClosed
                                  ? GestureDetector(
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          activityClosed = !activityClosed;
                                        });
                                      },
                                    )
                                  : GestureDetector(
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          activityClosed = !activityClosed;
                                        });
                                      },
                                    )
                            ],
                          ),
                        ),
                        activityClosed
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    AlMajlisCountCard(
                                      "drawables/post.png",
                                      "Posts",
                                      postCount.toString(),
                                      rightPadding: 6,
                                      onTap: () {
                                        if (selfProfile)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityViewTotalPost(core
                                                        .getCurrentUser()
                                                        .userId)),
                                          );
                                      },
                                    ),
                                    AlMajlisCountCard(
                                      "drawables/contact.png",
                                      "Contacts",
                                      contactCount.toString(),
                                      rightPadding: 6,
                                      leftPadding: 6,
                                      onTap: () {
                                        if (selfProfile)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityContact(
                                                  isContact: true,
                                                ),
                                              ));
                                      },
                                    ),
                                    AlMajlisCountCard(
                                      "drawables/message_white-01.png",
                                      "Messages",
                                      messageCount.toString(),
                                      leftPadding: 6,
                                      onTap: () {
                                        if (selfProfile)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityUserChatList()),
                                          );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        AlMajlisCountCard(
                                          "drawables/post.png",
                                          "Posts",
                                          postCount.toString(),
                                          rightPadding: 6,
                                          onTap: () {
                                            if (selfProfile)
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityViewTotalPost(
                                                            core
                                                                .getCurrentUser()
                                                                .userId)),
                                              );
                                          },
                                        ),
                                        AlMajlisCountCard(
                                          "drawables/contact.png",
                                          "Contacts",
                                          contactCount.toString(),
                                          rightPadding: 6,
                                          leftPadding: 6,
                                          onTap: () {
                                            if (selfProfile)
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityContact(
                                                      isContact: true,
                                                    ),
                                                  ));
                                          },
                                        ),
                                        AlMajlisCountCard(
                                          "drawables/message_white-01.png",
                                          "Messages",
                                          messageCount.toString(),
                                          leftPadding: 6,
                                          onTap: () {
                                            if (selfProfile)
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityUserChatList()),
                                              );
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        children: <Widget>[
                                          AlMajlisCountCard(
                                            "drawables/comment_white-01.png",
                                            "Replies",
                                            replyCount.toString(),
                                            rightPadding: 6,
                                          ),
                                          AlMajlisCountCard(
                                            "drawables/ic_heart_outline_white_18dp.png",
                                            "Likes",
                                            likeCount.toString(),
                                            rightPadding: 6,
                                            leftPadding: 6,
                                          ),
                                          AlMajlisCountCard(
                                            "drawables/invites.png",
                                            "Invites",
                                            inviteCount.toString(),
                                            rightPadding: 6,
                                            leftPadding: 6,
                                            onTap: () {
                                              if (selfProfile)
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityContact(),
                                                    ));
                                            },
                                          ),
                                          // AlMajlisCountCard(
                                          //   "drawables/update-01.png",
                                          //   "Forwards",
                                          //   forwardCount.toString(),
                                          //   leftPadding: 6,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 0 * 1.0, left: 0 * 1.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                //  if (null != onTap) onTap();
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          10.0) //         <--- border radius here
                                                      ),
                                                  color:
                                                      Constants.COLOR_DARK_GREY,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Image.asset(
                                                            "drawables/calls.png",
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 16.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            AlMajlisTextViewBold(
                                                              "Calls",
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          AlMajlisTextViewMedium(
                                                            callCount
                                                                .toString(),
                                                            size: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // AlMajlisCountCard(
                                          //   "drawables/share.png",
                                          //   "Shares",
                                          //   shareCount.toString(),
                                          //   rightPadding: 6,
                                          // ),
                                          // AlMajlisCountCard(
                                          //   "drawables/invites.png",
                                          //   "Invites",
                                          //   inviteCount.toString(),
                                          //   rightPadding: 6,
                                          //   leftPadding: 6,
                                          //   onTap: () {
                                          //     if (selfProfile)
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 ActivityContact(),
                                          //           ));
                                          //   },
                                          // ),
                                          // AlMajlisCountCard(
                                          //   "drawables/calls.png",
                                          //   "Calls",
                                          //   callCount.toString(),
                                          //   leftPadding: 6,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              AlMajlisDateCard(
                                "drawables/updates.png",
                                "Updated",
                                updatedAt,
                                rightPadding: 6,
                              ),
                              AlMajlisDateCard("drawables/user_since.png",
                                  "User Since", userSince,
                                  leftPadding: 6),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !selfProfile && posts.length > 0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AlMajlisTextViewBold(
                                      "Recent Posts",
                                      size: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityViewTotalPost(
                                                      widget.userId)),
                                        );
                                      },
                                      child: AlMajlisTextViewBold(
                                        "SEE ALL",
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              posts.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          left: 20,
                                          right: 20,
                                          bottom: 16),
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivitySinglePost(
                                                            id: posts
                                                                .elementAt(0)
                                                                .postId)),
                                              );
                                            },
                                            child: AlMajlisShortPostCard(
                                              posts
                                                  .elementAt(0)
                                                  .postUser
                                                  .thumbUrl,
                                              posts
                                                      .elementAt(0)
                                                      .postUser
                                                      .firstName +
                                                  " " +
                                                  posts
                                                      .elementAt(0)
                                                      .postUser
                                                      .lastName,
                                              timeago
                                                  .format(
                                                      posts
                                                          .elementAt(0)
                                                          .createdAt,
                                                      locale: 'en_short')
                                                  .toUpperCase(),
                                              posts.elementAt(0).text,
                                              id: posts
                                                  .elementAt(0)
                                                  .postUser
                                                  .userId,
                                              isPro: hasPro,
                                            ),
                                          ),
                                          posts.length > 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ActivitySinglePost(
                                                                    id: posts
                                                                        .elementAt(
                                                                            1)
                                                                        .postId)),
                                                      );
                                                    },
                                                    child:
                                                        AlMajlisShortPostCard(
                                                      posts
                                                          .elementAt(1)
                                                          .postUser
                                                          .thumbUrl,
                                                      posts
                                                              .elementAt(1)
                                                              .postUser
                                                              .firstName +
                                                          " " +
                                                          posts
                                                              .elementAt(1)
                                                              .postUser
                                                              .lastName,
                                                      timeago
                                                          .format(
                                                              posts
                                                                  .elementAt(1)
                                                                  .createdAt,
                                                              locale:
                                                                  'en_short')
                                                          .toUpperCase(),
                                                      posts.elementAt(1).text,
                                                      id: posts
                                                          .elementAt(1)
                                                          .postUser
                                                          .userId,
                                                      isPro: hasPro,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          if (posts.length > 2)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivitySinglePost(
                                                                id: posts
                                                                    .elementAt(
                                                                        2)
                                                                    .postId)),
                                                  );
                                                },
                                                child: AlMajlisShortPostCard(
                                                  posts
                                                      .elementAt(2)
                                                      .postUser
                                                      .thumbUrl,
                                                  posts
                                                          .elementAt(2)
                                                          .postUser
                                                          .firstName +
                                                      " " +
                                                      posts
                                                          .elementAt(2)
                                                          .postUser
                                                          .lastName,
                                                  timeago
                                                      .format(
                                                          posts
                                                              .elementAt(2)
                                                              .createdAt,
                                                          locale: 'en_short')
                                                      .toUpperCase(),
                                                  posts.elementAt(2).text,
                                                  id: posts
                                                      .elementAt(2)
                                                      .postUser
                                                      .userId,
                                                  isPro: hasPro,
                                                ),
                                              ),
                                            )
                                          else
                                            Container(),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        null != companyName && !companyName.isEmpty
                            ? Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        AlMajlisTextViewBold(
                                          "Experience",
                                          size: 24,
                                        ),
                                        Visibility(
                                            visible: selfProfile,
                                            child: InkWell(
                                              child: Image.asset(
                                                "drawables/edit.png",
                                                height: 20,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  showDelete = true;
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0,
                                        left: 20,
                                        right: 20,
                                        bottom: 16),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            if (showDelete && selfProfile) {
                                              if (null != _controller &&
                                                  _controller
                                                      .value.initialized) {
                                                try {
                                                  _controller.pause();
                                                } catch (e) {}
                                              }
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityWorkExperience(
                                                            fromProfile: true,
                                                          )));
                                              getUser();
                                            }
                                          },
                                          child: AlMajlisExperienceCard(
                                            null != user.companyThumb &&
                                                    !user.companyThumb.isEmpty
                                                ? user.companyThumb
                                                : "https://www.completeuniversityinfo.com/images/university_placeholder.png",
                                            occupation,
                                            companyName,
                                            workPeriod,
                                            deleteExperience: deleteCompany,
                                            showDelete:
                                                showDelete && selfProfile,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Visibility(
                                visible: selfProfile,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AlMajlisTextViewBold(
                                            "Experience",
                                            size: 24,
                                          ),
                                          Visibility(
                                              visible: selfProfile,
                                              child: GestureDetector(
                                                child: Image.asset(
                                                  "drawables/edit.png",
                                                  height: 15,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    showDelete = true;
                                                  });
                                                },
                                              ))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          left: 20,
                                          right: 20,
                                          bottom: 16),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (null != _controller &&
                                              _controller.value.initialized) {
                                            try {
                                              _controller.pause();
                                            } catch (e) {}
                                          }
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityWorkExperience(
                                                        fromProfile: true,
                                                      )));
                                          getUser();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0) //         <--- border radius here
                                                ),
                                            color: Constants.COLOR_DARK_GREY,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  size: 55,
                                                  color: Constants
                                                      .COLOR_PRIMARY_GREY,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: AlMajlisTextViewBold(
                                                      "ADD WORK EXPERIENCE",
                                                      size: 16,
                                                      color: Constants
                                                          .COLOR_PRIMARY_GREY,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        null != education
                            ? Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        AlMajlisTextViewBold(
                                          "Education",
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0,
                                        left: 20,
                                        right: 20,
                                        bottom: 16.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (null != _controller &&
                                            _controller.value.initialized) {
                                          try {
                                            _controller.pause();
                                          } catch (e) {}
                                        }
                                        if (selfProfile && showDelete) {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityEducation(
                                                        fromProfile: true,
                                                      )));
                                          getUser();
                                        }
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          AlMajlisExperienceCard(
                                            null != education.educationThumb &&
                                                    !education
                                                        .educationThumb.isEmpty
                                                ? education.educationThumb
                                                : "https://www.completeuniversityinfo.com/images/university_placeholder.png",
                                            education.degree,
                                            education.university,
                                            educationPeriod,
                                            deleteExperience: deleteEducation,
                                            showDelete:
                                                showDelete && selfProfile,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Visibility(
                                visible: selfProfile,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: <Widget>[
                                          AlMajlisTextViewBold(
                                            "Education",
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          left: 20,
                                          right: 20,
                                          bottom: 16),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (null != _controller &&
                                              _controller.value.initialized) {
                                            try {
                                              _controller.pause();
                                            } catch (e) {}
                                          }
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityEducation(
                                                        fromProfile: true,
                                                      )));
                                          getUser();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0) //         <--- border radius here
                                                ),
                                            color: Constants.COLOR_DARK_GREY,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  size: 55,
                                                  color: Constants
                                                      .COLOR_PRIMARY_GREY,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: AlMajlisTextViewBold(
                                                      "ADD EDUCATION",
                                                      size: 16,
                                                      color: Constants
                                                          .COLOR_PRIMARY_GREY,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        selfProfile
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AlMajlisTextViewBold(
                                      "Skills & Interests",
                                      size: 24,
                                    )
                                  ],
                                ),
                              )
                            : null != skillsAndExperiences &&
                                    skillsAndExperiences.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        AlMajlisTextViewBold(
                                          "Skills & Interests",
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 20, right: 20, bottom: 120.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: selfProfile,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 12.0),
                                  child: GestureDetector(
                                    child: openAddNewSkill
                                        ? Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      10.0) //<--- border radius here
                                                  ),
                                              color: Constants.COLOR_DARK_GREY,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: TextField(
                                                        controller:
                                                            interestController,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ProximaNovaSemiMedium',
                                                            color:
                                                                Colors.white),
                                                        onSubmitted: (term) {
                                                          FocusNode()
                                                              .requestFocus(
                                                                  FocusNode());
                                                          addSkillAndInterest(
                                                              interestController
                                                                  .text);
                                                        },
                                                        decoration:
                                                            new InputDecoration(
                                                          hintText:
                                                              "Skill/Interest",
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          hintStyle: TextStyle(
                                                              fontFamily:
                                                                  'ProximaNovaSemiMedium',
                                                              color: Constants
                                                                  .COLOR_PRIMARY_GREY),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      10.0) //         <--- border radius here
                                                  ),
                                              color: Constants.COLOR_DARK_GREY,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    onTap: () {
                                      setState(() {
                                        openAddNewSkill = !openAddNewSkill;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showSkils,
                                child: Container(
                                  height: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            controller: skillController,
                                            itemCount:
                                                skillsAndExperiences.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        height: 50,
                                                        width: skillsAndExperiences[
                                                                        index]
                                                                    .length <
                                                                8
                                                            ? 80.0
                                                            : skillsAndExperiences[
                                                                            index]
                                                                        .length >
                                                                    16
                                                                ? 210
                                                                : 140,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0) //         <--- border radius here
                                                                  ),
                                                          color: Constants
                                                              .COLOR_DARK_GREY,
                                                          // color: Colors.red,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: AlMajlisTextViewMedium(
                                                                    skillsAndExperiences[
                                                                        index],
                                                                    maxLines: 1,
                                                                    align: TextAlign
                                                                        .center),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: showDelete &&
                                                          selfProfile,
                                                      child: Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: GestureDetector(
                                                          child:
                                                              AlMajlisImageIcons(
                                                            "drawables/delete-01.png",
                                                            iconHeight: 16,
                                                          ),
                                                          onTap: () {
                                                            deleteSkill(index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: openBookingSheet,
                child: Stack(
                  children: <Widget>[
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: GestureDetector(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5)),
                          ),
                          onTap: () {
                            setState(() {
                              openBookingSheet = false;
                            });
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.4,
                        decoration: BoxDecoration(
                            color: Constants.COLOR_DARK_GREY,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0))),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            openBookingSheet = false;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: AlMajlisTextViewBold(
                                            "CANCEL",
                                            size: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 60.0, bottom: 8.0),
                                      child: AlMajlisTextViewBold(
                                        "Book a Meeting Call",
                                        size: 14.0,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          null != imageLink &&
                                                  !imageLink.isEmpty
                                              ? AlMajlisProfileImageWithStatus(
                                                  imageLink,
                                                  30.0,
                                                  isPro: hasPro,
                                                )
                                              : Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: hasPro
                                                          ? Constants
                                                              .COLOR_PRIMARY_TEAL
                                                          : Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                Colors.purple,
                                                                Colors.teal
                                                              ])),
                                                    ),
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: AlMajlisTextViewRegular(
                                              userName,
                                              size: 16,
                                            ),
                                          ),
//                                          Icon(
//                                            Icons.done,
//                                            color: Colors.teal,
//                                            size: 16,
//                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: AlMajlisTextViewRegular(
                                                metttingMinutes.toString() +
                                                    " Minutes",
                                                size: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: AlMajlisTextViewRegular(
                                                  "Contact details provided upon confirmation",
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: AlMajlisDatePicker(
                                    "Date & time",
                                    bookingDateTimeChanged,
                                    controller: mettingTimeController,
                                    suffixIcon: Icon(Icons.calendar_today),
                                    startDate: DateTime.now(),
                                    endDate: DateTime(DateTime.now().year + 2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          AlMajlisTextViewRegular(
                                            "Payment Method",
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: InkWell(
                                          splashColor: Colors.blueAccent,
//                                          onTap: () {
//                                            setState(() {
//                                              radioBtnData.forEach((radioBtn) =>
//                                              radioBtn.isSelected = false);
//                                              radioBtnData[0].isSelected = true;
//                                            });
//                                          },
                                          child: new RadioItem(
                                              radioBtnData[0], Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Constants.COLOR_PRIMARY_GREY,
                                  thickness: 2.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      AlMajlisTextViewBold(
                                        "SUBTOTAL",
                                        size: 16,
                                      ),
                                      AlMajlisTextViewBold(
                                        meetingCharges.toString() + " BD",
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      AlMajlisTextViewBold(
                                        "SERVICE CHARGE",
                                        size: 16,
                                      ),
                                      AlMajlisTextViewBold(
                                        serviceCharge.toString() + " BD",
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      AlMajlisTextViewBold(
                                        "TOTAL",
                                        size: 16,
                                      ),
                                      AlMajlisTextViewBold(
                                        totalCharges.toString() + " BD",
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      AlMajlisButton(
                                        "PROCEED TO PAYMENT",
                                        Constants.TEAL,
                                        bookMeeting,
                                        icon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Visibility(
              //   visible: !openBookingSheet && selfProfile,
              //   child: Container(
              //     height: double.infinity,
              //     width: double.infinity,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: <Widget>[AlMajlisNavigationBar(3, getUser)],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  shareToUsers(List<SearchModel> users, index) {
    Navigator.pop(_context);
    String idString = 'userId=' + user.userId;
    for (int index = 0; index < users.length; index++) {
      getChats(user, users.elementAt(index).user, idString);
    }
    Fluttertoast.showToast(
        msg: "Shared to selected Users",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2);
  }

  Future<void> newMessage(
      User myUser, User otherUser, String chatRoomId, String text) async {
    Map<String, dynamic> userDataMap = {
      "sender_user_id": myUser.userId,
      "sender_name": myUser.firstName + " " + myUser.lastName,
      "text": text,
      'time': DateTime.now().millisecondsSinceEpoch
    };
    _chatsInstance
        .document(chatRoomId)
        .collection("messages")
        .add(userDataMap)
        .then((value) {
      print("value added");
    }).catchError((e) {
      print(e.toString());
    });

// Update Time for self document
    var user = await _usersInstance
        .where('myUserId', isEqualTo: myUser.userId)
        .getDocuments();

    if (user.documents.length > 0) {
      var convoList = _usersInstance
          .document(user.documents.first.documentID)
          .collection("conversations");

      var receipentUser = await convoList
          .where('id', isEqualTo: otherUser.userId)
          .getDocuments();

      if (receipentUser.documents.length > 0) {
        _usersInstance
            .document(user.documents.first.documentID)
            .collection("conversations")
            .document(receipentUser.documents.first.documentID)
            .updateData({'time': DateTime.now().millisecondsSinceEpoch});
      } else {
        Map<String, dynamic> userMap = {
          "id": otherUser.userId,
          "thumb": otherUser.thumbUrl,
          "occupation": otherUser.occupation,
          "country": otherUser.country,
          "city": otherUser.city,
          'time': DateTime.now().millisecondsSinceEpoch,
          'name': otherUser.firstName + " " + otherUser.lastName,
          'isPro': otherUser.isPro
        };
        convoList.add(userMap).catchError((e) {
          print(e.toString());
        });
      }
    }

//// Update Time for reciepent document
    user = await _usersInstance
        .where('myUserId', isEqualTo: otherUser.userId)
        .getDocuments();

    if (user.documents.length > 0) {
      var convoList = _usersInstance
          .document(user.documents.first.documentID)
          .collection("conversations");

      var receipentUser =
          await convoList.where('id', isEqualTo: myUser.userId).getDocuments();

      if (receipentUser.documents.length > 0) {
        _usersInstance
            .document(user.documents.first.documentID)
            .collection("conversations")
            .document(receipentUser.documents.first.documentID)
            .updateData({'time': DateTime.now().millisecondsSinceEpoch});
      } else {
        Map<String, dynamic> userMap = {
          "id": myUser.userId,
          "thumb": myUser.thumbUrl,
          "occupation": myUser.occupation,
          "country": myUser.country,
          "city": myUser.city,
          'time': DateTime.now().millisecondsSinceEpoch,
          'name': myUser.firstName + " " + myUser.lastName,
          'isPro': myUser.isPro
        };
        convoList.add(userMap).catchError((e) {
          print(e.toString());
        });
      }
    }
  }

  Future getChats(User myUser, User otherUser, idString) async {
    //Checking if these two users have a chat room created.
    String chatRoomId;
    String linkText = await createLink(idString);
    linkText = "Check this post " + linkText;
    var userData = await _chatsInstance
        .where('userId1', isEqualTo: otherUser.userId)
        .where('userId2', isEqualTo: myUser.userId)
        .getDocuments();
    if (userData.documents.length > 0) {
      print(userData.documents.first.documentID);
      chatRoomId = userData.documents.first.documentID;
      newMessage(myUser, otherUser, chatRoomId, linkText);
    } else {
      var userData = await _chatsInstance
          .where('userId1', isEqualTo: myUser.userId)
          .where('userId2', isEqualTo: otherUser.userId)
          .getDocuments();
      if (userData.documents.length > 0) {
        print(userData.documents.first.documentID);
        chatRoomId = userData.documents.first.documentID;
        newMessage(myUser, otherUser, chatRoomId, linkText);
      } else {
        //Added new user data to chat room
        Map<String, String> userDataMap = {
          "userId1": myUser.userId,
          "userId2": otherUser.userId,
        };
        _chatsInstance
            .add(userDataMap)
            .then((value) => chatRoomId = value.documentID)
            .catchError((e) {
          print(e.toString());
        });

        var user = await _usersInstance
            .where('myUserId', isEqualTo: myUser.userId)
            .getDocuments();

        if (user.documents.length <= 0) {
          Map<String, String> userMap = {
            "myUserId": myUser.userId,
          };

          _usersInstance.add(userMap).catchError((e) {
            print(e.toString());
          });
        }

        user = await _usersInstance
            .where('myUserId', isEqualTo: otherUser.userId)
            .getDocuments();

        if (user.documents.length <= 0) {
          Map<String, String> userMap = {
            "myUserId": otherUser.userId,
          };

          _usersInstance
              .add(userMap)
              .then((value) =>
                  newMessage(myUser, otherUser, chatRoomId, linkText))
              .catchError((e) {
            print(e.toString());
          });
        }
      }
    }
  }

  void reportClicked() {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return DialogReport(0);
        }).then((value) {
      reportUser(Constants.reportReasons.elementAt(value));
    });
  }

  void reportUser(String reason) async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.reportUser(user.userId, reason);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    reportUser(reason);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        Fluttertoast.showToast(
            msg: "Account Has been reported",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
      }
    }
  }

  bookingDateTimeChanged(DateTime date) async {
    List<DateTime> availableSlots = await getAvailableTimeSlots(date);
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return DialogAvailableTimeSlot(
              availableSlots, user.callDuration, timezoneName);
        }).then((value) {
      bookingDate = DateTime(
          date.year,
          date.month,
          date.day,
          availableSlots.elementAt(value).hour,
          availableSlots.elementAt(value).minute);
      setState(() {
        String timeMeridian = bookingDate.hour > 12 ? " PM" : " AM";
        String hour = bookingDate.hour > 12
            ? (bookingDate.hour - 12).toString()
            : bookingDate.hour.toString();
        if (int.parse(hour) < 10) {
          hour = "0" + hour;
        }
        print(bookingDate.minute.toString());
        String minute = bookingDate.minute < 10 ? ":0" : ":";
        minute += bookingDate.minute.toString();
        print(minute);
        mettingTimeController.text =
            mettingTimeController.text + " " + hour + minute + timeMeridian;
      });
      print(bookingDate);
    });
  }

  void navigateToEditProfile() async {
    if (null != _controller && _controller.value.initialized) {
      try {
        _controller.pause();
      } catch (e) {}
    }
    await Navigator.of(_context).push(MaterialPageRoute(
        builder: (context) => ActivityEditProfile(
              fromProfile: true,
            )));
    print("after await");
    getUser();
  }

  Future<List<DateTime>> getAvailableTimeSlots(date) async {
    core.startLoading(_context);
    ResponseAvailableTimeSlots response;
    try {
      response = await core.getAvailabelSlots(widget.userId, date);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    deleteCompany();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        return response.payload;
      }
    }
  }

  void getUser() async {
    core.startLoading(_context);
    ResponseUser response;
    try {
      print(widget.userId);
      if (null != widget.userId)
        response = await core.getUser(id: widget.userId);
      else
        response = await core.getUser();
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getUser();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        user = response.payload;
        progress = 0;
        setState(() {
          showDelete = false;
          timezoneName = user.timeZoneName;

          if (user.userId == core.getCurrentUser().userId) {
            selfProfile = true;
          }
          if (null == user.isPro) {
            user.isPro = false;
          }
          if (user.isPro) {
            hasPro = user.isPro;
            progress += 1;
          }
          if (null != user.isPublic) {
            isPublic = user.isPublic;
          }
          print(user.isFollowing);
          if (null != user.isFollowing) {
            isAdded = user.isFollowing;
          }
          if (null != user.firstName &&
              !user.firstName.isEmpty &&
              null != user.lastName &&
              !user.lastName.isEmpty) {
            userName = user.firstName + " " + user.lastName;
            progress += 1;
          } else {
            userName = "";
          }
          if (null != user.bio && !user.bio.isEmpty) {
            bio = user.bio;
            progress += 1;
          } else {
            bio = "";
          }
          if (null != user.link && !user.link.isEmpty) {
            link = user.link;
            progress += 1;
          } else {
            link = "";
          }
          if (null != user.occupation && !user.occupation.isEmpty) {
            occupation = user.occupation;
            progress += 1;
          } else {
            occupation = "";
          }
          if (null != user.companyName && !user.companyName.isEmpty) {
            companyName = user.companyName;
          } else {
            companyName = "";
          }
          if (null != user.workStart) {
            var dateFormat = DateFormat("MMM y");
            startDate = dateFormat
                .format(user.workStart.add(DateTime.now().timeZoneOffset));
          } else {
            startDate = null;
          }
          if (null != user.workEnd) {
            var dateFormat = DateFormat("MMM y");
            endDate = null != user.workEnd
                ? dateFormat
                    .format(user.workEnd.add(DateTime.now().timeZoneOffset))
                : "-present";
          } else {
            endDate = null;
          }
          if (user.isCurrent) {
            workPeriod = startDate != null
                ? startDate + " - Present"
                : "" + " - Present";
          } else {
            if (null != startDate && null != endDate)
              workPeriod = startDate + " - " + endDate;
          }
          if (null != user.createdAt) {
            var dateFormat = DateFormat("MMM d y");
            userSince = dateFormat
                .format(user.createdAt.add(DateTime.now().timeZoneOffset));
          }
          if (null != user.updatedAt) {
            var dateFormat = DateFormat("MMM d ");
            updatedAt = dateFormat
                .format(user.updatedAt.add(DateTime.now().timeZoneOffset));

            String hour = user.updatedAt.hour < 10
                ? "0" + user.updatedAt.hour.toString()
                : user.updatedAt.hour.toString();

            String min = user.updatedAt.minute < 10
                ? "0" + user.updatedAt.minute.toString()
                : user.updatedAt.minute.toString();

            updatedAt = updatedAt + hour + ":" + min;
          }
          if (null != user.thumbUrl && !user.thumbUrl.isEmpty) {
            imageLink = user.thumbUrl;
            progress += 1;
          } else {
            imageLink = "";
          }
          if (null != user.city && !user.city.isEmpty) {
            country = user.city;
            progress += 1;
          } else {
            country = "";
          }
          if (null != user.country && !user.country.isEmpty) {
            if (country.length > 1) {
              country += ", " + user.country;
              progress += 1;
            } else
              country = user.country;
          } else {
            country = "";
          }
          if (null != user.education) {
            education = user.education;
            print(education);
            var dateFormat = DateFormat("MMM y");
            if (null != education.educationStart &&
                null != education.educationEnd) {
              String educationstartDate = dateFormat.format(
                  education.educationStart.add(DateTime.now().timeZoneOffset));
              String educationendDAte = null != education.educationEnd
                  ? dateFormat.format(
                      education.educationEnd.add(DateTime.now().timeZoneOffset))
                  : "Present";
              if (education.isCurrent) {
                educationPeriod = educationstartDate + " - Present";
              } else {
                if (null != educationstartDate && null != educationendDAte)
                  educationPeriod =
                      educationstartDate + " - " + educationendDAte;
              }
            }
          } else {
            education = null;
          }

//          education = user.education;
//            print(education);
//          education = null;

          if (null != user.skills) {
            skillsAndExperiences = user.skills;
          } else {
            skillsAndExperiences = [];
//            skillsAndExperiences = List();
          }
          if (null != user.videoUrl && !user.videoUrl.isEmpty) {
            //TODO : video
            if (null != user.videoIntroThumb && !user.videoIntroThumb.isEmpty) {
              videoThumb = user.videoIntroThumb;
            }
            videoLink = user.videoUrl;
            progress += 1;
            _controller = VideoPlayerController.network(videoLink)
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
            _controller.setLooping(true);
          } else {
            videoLink = "";
            _controller = null;
          }
          if (null != user.postCount) {
            postCount = user.postCount;
          }
          if (null != user.contactCount) {
            contactCount = user.contactCount;
          }
          if (null != user.messageCount) {
            messageCount = user.messageCount;
          }
          if (null != user.likeCount) {
            likeCount = user.likeCount;
          }
          if (null != user.forwardCount) {
            forwardCount = user.forwardCount;
          }

          if (null != user.shareCount) {
            shareCount = user.shareCount;
          }
          if (null != user.inviteCount) {
            inviteCount = user.inviteCount;
          }
          if (null != user.callCount) {
            callCount = user.callCount;
          }
          if (null != user.profileViewCount) {
            profileViews = user.profileViewCount;
          }
          if (null != user.replyCounts) {
            print("replyCounts+++++++++++++++++++++++++++++++++++" +
                user.replyCounts.toString());
            replyCount = user.replyCounts;
          }

          if (hasPro) {
            bookingLeft = user.attendedMeetingCount;
            bookingRight = user.meetingCount;
          } else {
            bookingLeft = user.attendedBookingCount;
            bookingRight = user.bookingCount;
          }
          if (null != user.meetingCharges) {
            meetingCharges = user.meetingCharges;
          }
          if (null != user.serviceCharges) {
            serviceCharge = user.serviceCharges;
          }
          if (null != user.totalCharges) {
            totalCharges = user.totalCharges;
          }
          if (null != user.phone_number) {
            phoneNumber = user.phone_number;
          }

          progress += 1;
        });
      }
    }
    core.stopLoading(_context);
  }

  void deleteCompany() async {
    user
      ..workEnd = null
      ..workStart = null
      ..companyName = ""
      ..isCurrent = false
      ..companyThumb = null;

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    deleteCompany();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        core.updateSession(core.getToken(), user);
        print("in success");
        getUser();
      }
    }
  }

  void deleteEducation() async {
    user..education = null;

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        getUser();
      }
    }
  }

  void deleteSkill(deleteIndex) async {
    skillsAndExperiences.removeAt(deleteIndex);
    user..skills = skillsAndExperiences;

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    deleteSkill(deleteIndex);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        getUser();
      }
    }
  }

  void addSkillAndInterest(skill) async {
    if (null != skillsAndExperiences) skillsAndExperiences.add(skill);

    user..skills = skillsAndExperiences;

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    addSkillAndInterest(skill);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        getUser();
        interestController.text = "";
        openAddNewSkill = !openAddNewSkill;
      }
    }
  }

  void getUtils() async {
    core.startLoading(_context);
    ResponseUtils response;
    try {
      response = await core.getUtils();
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (e) {
      print(e);
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getUtils();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        setState(() {
//          if (null != response.payload.serviceCharge) {
//            if (meetingCharges > 0) {
//              serviceCharge =
//                  (meetingCharges * response.payload.serviceCharge) / 100;
//            }
//          }
          if (null != response.payload.proSubscriptionCharge) {
            proCharges = response.payload.proSubscriptionCharge;
          }
        });
      }
    }
  }

  void addConnection() async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.addConnection(widget.userId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (e) {
      print(e);
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    addConnection();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        getUser();
      }
    }
  }

  void removeConnection() async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.removeConnection(widget.userId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (e) {
      print(e);
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    removeConnection();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        getUser();
      }
    }
  }

  void newForward(id) async {
    ResponseOk response;
    User user;
    try {
      response = await core.newForward(id);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  void newCall(id) async {
    ResponseOk response;
    User user;
    try {
      response = await core.newCall(id);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  void getPosts() async {
    core.startLoading(_context);
    ResponsePosts response;
    try {
      response = await core.getUserPosts(widget.userId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getPosts();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    core.stopLoading(_context);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        setState(() {
          posts = response.payload;
        });
      }
    }
  }

  Future<String> createLink(idString) async {
    print("in create link");
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://almajlis.page.link',
      link: Uri.parse('https://test/welcome?' + idString),
      androidParameters: AndroidParameters(
        packageName: "com.almajlis.almajlis",
      ),
      iosParameters: IosParameters(
        bundleId: "com.almajlis.almajlis",
        appStoreId: '1214611133',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    var shortLink = await parameters.buildShortLink();
    var shortUrl = shortLink.shortUrl;

    print(shortUrl);

    return shortUrl.toString();
  }

  copyLink() async {
    String idString = 'userId=' + user.userId;
    String link = await createLink(idString);
    Share.share('Check out this user on Majlis ' + link);
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser();
    getUtils();
    if (null != widget.userId) {
      getPosts();
    }
  }
}
