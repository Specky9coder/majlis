import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:almajlis/activities/ActivityAddNewPost.dart';
import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityEditPost.dart';
import 'package:almajlis/activities/ActivityLogin.dart';
import 'package:almajlis/activities/ActivityPhotoZoom.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityReplyToPost.dart';
import 'package:almajlis/activities/ActivitySearch.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/core/constants/countryStateConstant.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePosts.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisCountries.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/services/NavigationService.dart';
import 'package:almajlis/services/PushRegisterService.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/BottomSheetOperations.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';
import 'package:almajlis/views/bottomsheets/PostShareBottomSheet.dart';
import 'package:almajlis/views/bottomsheets/ReportPostBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlMajlisNavigationBar.dart';
import 'package:almajlis/views/components/AlMajlisRadioButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/dialogs/DialogReport.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ActivityHomeScreens.dart';
import 'ActivityVideoCallOperationsScreen.dart';
import 'MyCustomClipper.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityPosts extends StatefulWidget {
  ActivityPosts({Key key}) : super(key: key);

  @override
  _ActivityPostsState createState() => _ActivityPostsState();
}

class _ActivityPostsState extends ActivityStateBase<ActivityPosts>
    with WidgetsBindingObserver {
  TextEditingController searchController = TextEditingController();
  final _chatsInstance = Firestore.instance.collection("chats");
  final _usersInstance = Firestore.instance.collection("users");
  Stream users;
  bool isListItemSelected = false;
  bool isSelected = false;
  bool toogleValue = false;
  bool toogleValue1 = false;
  bool isIncreasedFavCount = false;
  List<AlMajlisPost> posts = List();
  List<User> serachUsers = List();
  int counter = 0;
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool fetchMore = true;
  var lat;
  var lng;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isCameraClicked = false;
  bool isSearchBtnClicked = false;
  bool isSharePostBtnClicked = false;
  bool isSelectRadioBtn = false;
  bool isMoreSelected = false;
  bool isUserLoggedIn = false;
  String imageUrl = "";
  bool isPro = false;

  int selectedDistance = 0;
  String selectedCountry;
  AlMajlisCountries countries;
  List<String> countryList = List();
  List<int> distanceList = [10, 15, 20, 25, 30, 50, 100];

  File _pickedImage;
  final picker = ImagePicker();
  BuildContext _context;
  Timer searchOnStoppedTyping;
  User user;

  void _onRefresh() async {
    // monitor network fetch
    if (isUserLoggedIn) getPosts(DateTime.now());
    getPosts(DateTime.now());
    // if failed,use refreshFailed()
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserLoggedIn = core.isUserLoggedIn();

    if (null == core.getCurrentUser() ||
        core.getCurrentUser().firstName == "" ||
        core.getCurrentUser().firstName == null) {
      isUserLoggedIn = false;
    }
    countries = AlMajlisCountries.fromMap(countryState);
    for (int index = 0; index < countries.countries.length; index++) {
      countryList.add(countries.countries.elementAt(index).name);
    }
    WidgetsBinding.instance.addObserver(this);
    initDynamicLinks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initDynamicLinks();
    }
  }

  _onChangeHandler(String value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () {
          if (value.length > 2) {}
        }));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: Scaffold(
          key: scaffoldState,
          body: Container(
            color: Colors.black,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isUserLoggedIn
                              ? InkWell(
                                  child: AlMajlisRoundIconButton(
                                      "drawables/settings.png",
                                      isSelected: isSelected),
                                  onTap: () {
                                    setState(() {
                                      isSelected = !isSelected;
                                    });
                                  },
                                )
                              : Row(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "drawables/majlislogo.png",
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10.0) //         <--- border radius here
                                              ),
                                          color: Constants.COLOR_DARK_GREY),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: AlMajlisTextViewBold(
                                        "Majlis",
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                          isSelected
                              ? GestureDetector(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        getPosts(new DateTime.now());
                                      },
                                      child: AlMajlisTextViewBold(
                                        "APPLY",
                                        size: 12,
                                        color: Constants.COLOR_PRIMARY_TEAL,
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                )
                              : Visibility(
                                  visible: isUserLoggedIn,
                                  child: GestureDetector(
                                    child: AlMajlisRoundIconButton(
                                        "drawables/searchwhite.png",
                                        isSelected: false),
                                    onTap: () {
                                      setState(() {
                                        // isSearchBtnClicked = true;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivitySearch(
                                                    isFromActivityPost: true,
                                                  )),
                                        );
                                      });
                                    },
                                  ),
                                )
                        ],
                      ),
                      isUserLoggedIn
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                children: <Widget>[
                                  if (isSelected)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  child: Row(
                                                children: <Widget>[
                                                  AlMajlisTextViewMedium(
                                                    "Majlis",
                                                    size: 16,
                                                  ),
                                                  AlMajlisTextViewMedium(
                                                    " Pro ",
                                                    size: 16,
                                                    color: Constants
                                                        .COLOR_DARK_TEAL,
                                                  ),
                                                  AlMajlisTextViewMedium(
                                                    "users only",
                                                    size: 16,
                                                  ),
                                                ],
                                              )),
                                              Switch(
                                                value: toogleValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    toogleValue = value;
                                                  });
                                                },
                                                activeColor: Colors.green,
                                                inactiveTrackColor: Constants
                                                    .COLOR_PRIMARY_GREY,
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.white,
                                          ),
//                                              Row(
//                                                children: <Widget>[
//                                                  Expanded(
//                                                    child:
//                                                        AlMajlisTextViewMedium(
//                                                      "Online Users Only",
//                                                      size: 16,
//                                                    ),
//                                                  ),
//                                                  Switch(
//                                                    value: toogleValue1,
//                                                    onChanged: (value) {
//                                                      setState(() {
//                                                        toogleValue1 = value;
//                                                      });
//                                                    },
//                                                    activeColor: Colors.green,
//                                                    inactiveTrackColor:
//                                                        Constants
//                                                            .COLOR_PRIMARY_GREY,
//                                                  )
//                                                ],
//                                              ),
//                                              Divider(
//                                                color: Colors.white,
//                                              ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  AlMajlisTextViewMedium(
                                                    "Country",
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Container(
                                                  height: 40,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          countryList.length,
                                                      itemBuilder:
                                                          (BuildContext ctxt,
                                                              int index) {
                                                        bool isCountySelected =
                                                            false;
                                                        if (selectedCountry ==
                                                            countryList
                                                                .elementAt(
                                                                    index)) {
                                                          isCountySelected =
                                                              true;
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              width: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10.0) //         <--- border radius here
                                                                        ),
                                                                color: isCountySelected
                                                                    ? Constants
                                                                        .COLOR_PRIMARY_TEAL
                                                                    : Constants
                                                                        .COLOR_DARK_GREY,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          AlMajlisTextViewMedium(
                                                                        countryList
                                                                            .elementAt(index),
                                                                        align: TextAlign
                                                                            .center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (selectedCountry ==
                                                                    countryList
                                                                        .elementAt(
                                                                            index)) {
                                                                  selectedCountry =
                                                                      null;
                                                                } else {
                                                                  selectedCountry =
                                                                      countryList
                                                                          .elementAt(
                                                                              index);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.white,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AlMajlisTextViewMedium(
                                                "Distance",
                                                size: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Container(
                                                  height: 40,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          distanceList.length,
                                                      itemBuilder:
                                                          (BuildContext ctxt,
                                                              int index) {
                                                        bool
                                                            isDistanceSelected =
                                                            false;
                                                        if (selectedDistance ==
                                                            distanceList
                                                                .elementAt(
                                                                    index)) {
                                                          isDistanceSelected =
                                                              true;
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              width: 75,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10.0) //         <--- border radius here
                                                                        ),
                                                                color: isDistanceSelected
                                                                    ? Constants
                                                                        .COLOR_PRIMARY_TEAL
                                                                    : Constants
                                                                        .COLOR_DARK_GREY,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          AlMajlisTextViewMedium(
                                                                        distanceList.elementAt(index).toString() +
                                                                            " km",
                                                                        align: TextAlign
                                                                            .center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (selectedDistance ==
                                                                    distanceList
                                                                        .elementAt(
                                                                            index)) {
                                                                  selectedDistance =
                                                                      0;
                                                                } else {
                                                                  selectedDistance =
                                                                      distanceList
                                                                          .elementAt(
                                                                              index);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            null != imageUrl &&
                                                    !imageUrl.isEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ActivityProfile()),
                                                      );
                                                    },
                                                    child:
                                                        AlMajlisProfileImageWithStatus(
                                                            imageUrl, 50.0,
                                                            isPro: isPro),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ActivityProfile()),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: isPro
                                                              ? Constants
                                                                  .COLOR_PRIMARY_TEAL
                                                              : Colors.white),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    Colors
                                                                        .purple,
                                                                    Colors.teal
                                                                  ])),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            Expanded(
                                                child: Container(
                                              height: 45.0,
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              padding: EdgeInsets.only(
                                                  left: 12.0, right: 12.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: Constants
                                                      .COLOR_DARK_GREY),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ActivityAddNewPost()),
                                                        );
                                                        getPosts(
                                                            DateTime.now());
                                                      },
                                                      child: Text(
                                                        "who are you looking for?",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ProximaNovaMedium',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        scaffoldState
                                                            .currentState
                                                            .showBottomSheet((context) =>
                                                                PostMenuBottomSheet(
                                                                    getImageFromCamera,
                                                                    getImageFromGallary));
                                                      },
                                                      child: Image.asset(
                                                        "drawables/add_image-01.png",
                                                        height: 20,
                                                      )),
                                                ],
                                              ),
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: AlMajlisButton(
                                          "SIGN IN", Constants.TRANS, () async {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityLogin()))
                                            .then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                        // setState(() {
                                        //   // isUserLoggedIn =
                                        //   //     core.isUserLoggedIn();
                                        //   // getPosts(DateTime.now());
                                        //   Navigator.of(context).pushReplacement(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               Home()));
                                        // });
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: AlMajlisButton(
                                          "SIGN UP", Constants.TEAL, () async {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityLogin()))
                                            .then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                        // setState(() {
                                        //   // isUserLoggedIn =
                                        //   //     core.isUserLoggedIn();
                                        //   // getPosts(DateTime.now());
                                        //   Navigator.of(context).pushReplacement(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               Home()));
                                        // });
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () {
                            getPosts(DateTime.now(), isPulltorefresh: true);
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: posts.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                if (index == posts.length - 1) {
                                  if (fetchMore) {
                                    Future.delayed(Duration(seconds: 1), () {
                                      getPosts(
                                          posts
                                              .elementAt(posts.length - 1)
                                              .createdAt,
                                          isPaginationCall: true);
                                    });
                                  }
                                }
                                return PostListItem(context, index);
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: isSharePostBtnClicked ? true : false,
                  child: Stack(
                    children: <Widget>[
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 420,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Constants.COLOR_DARK_GREY,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSharePostBtnClicked = false;
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
                                        "Share post with",
                                        size: 14.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 32.0,
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                padding: EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Constants.COLOR_PRIMARY_TEAL_SHADOW),
                                child: TextField(
                                  controller: searchController,
                                  autofocus: true,
                                  onTap: () {},
                                  style: TextStyle(
                                    fontFamily: 'ProximaNovaSemiBold',
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor:
                                        Constants.COLOR_PRIMARY_TEAL_SHADOW,
                                    prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white30,
                                            size: 20,
                                          ),
                                        )),
                                    hintText: 'Search People',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: "ProximaNovaSemiBold",
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200.0,
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 12.0),
                                // child: Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: 3,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        width: double.infinity,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                AlMajlisProfileImageWithStatus(
                                                    "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F593b2e4b31358e03e55a0e8c%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D634%26cropX2%3D2468%26cropY1%3D39%26cropY2%3D1874",
                                                    50.0),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AlMajlisTextViewBold(
                                                                "Khalid Janahi",
                                                                size: 16,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.teal,
                                                              size: 12,
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .blueAccent,
                                                              onTap: () {
                                                                setState(() {
                                                                  // radioBtnData.forEach(
                                                                  //     (radioBtn) => radioBtn.isSelected = false);
                                                                  // radioBtnData[index].isSelected = true;
                                                                  //radioBtnData[index].isSelected = true;
                                                                  if (isSelectRadioBtn) {
                                                                    isSelectRadioBtn =
                                                                        false;
                                                                  } else {
                                                                    isSelectRadioBtn =
                                                                        true;
                                                                  }
                                                                });
                                                              },
                                                              child: new RadioItem(
                                                                  RadioModel(
                                                                      isSelectRadioBtn
                                                                          ? true
                                                                          : false,
                                                                      ""),
                                                                  Constants
                                                                      .COLOR_DARK_GREY),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AlMajlisTextViewMedium(
                                                                "UI/UX Designer",
                                                                size: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              //  ),
                              Divider(
                                height: 2,
                                color: Colors.white,
                              ),
                              GestureDetector(
                                child: shareLinkWidgetRow(
                                    context, Icons.link, "Copy link to post"),
                              ),
                              shareLinkWidgetRow(context, Icons.file_upload,
                                  "Share post via..."),
                              Container(
                                width: 300.0,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 12.0),
                                padding: EdgeInsets.only(
                                    left: 2.0,
                                    right: 2.0,
                                    top: 3.0,
                                    bottom: 3.0),
                                decoration: BoxDecoration(
                                  color: Constants.COLOR_DARK_TEAL,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Constants.COLOR_PRIMARY_TEAL,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(1.0,
                                          1.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: FlatButton(
                                  color: Constants.COLOR_DARK_TEAL,
                                  onPressed: () {},
                                  child: Text(
                                    "SEND",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Visibility(
                //   visible: isUserLoggedIn,
                //   child: Container(
                //     height: double.infinity,
                //     width: double.infinity,
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: <Widget>[AlMajlisNavigationBar(0, getPosts)],
                //     ),
                //   ),
                // )
              ],
            ),
          )),
    );
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

  copyLink(int index) async {
    Navigator.pop(context);
    String idString = 'postId=' + posts.elementAt(index).postId;
    String link = await createLink(idString);
    ClipboardManager.copyToClipBoard(link).then((result) {
      Fluttertoast.showToast(
          msg: "Copied To Clipboard",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    });
  }

  shareLink(int index) async {
    Navigator.pop(context);
    String idString = 'postId=' + posts.elementAt(index).postId;
    String link = await createLink(idString);
    Share.share('Check out this post on AlMajlis ' + link);
  }

  shareToUsers(List<SearchModel> users, index) {
    Navigator.pop(context);
    String idString = 'postId=' + posts.elementAt(index).postId;
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
        .then((value) {})
        .catchError((e) {
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

  void newShare(id) async {
    ResponseOk response;
    User user;
    try {
      response = await core.newShare(id);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  void getPosts(DateTime date,
      {bool isPaginationCall = false, bool isPulltorefresh = false}) async {
    if (!isPulltorefresh) {
      core.startLoading(_context);
    }
    ResponsePosts response;
    try {
      print("lat++++++++++++++++++++=");
      print(lat);
      print("lng++++++++++++++++++++++");
      print(lng);
      response = await core.getPosts(
          date,
          selectedCountry,
          toogleValue,
          selectedDistance == 0 ? null : (selectedDistance * 1000).toString(),
          lat,
          lng);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      if (!isPulltorefresh) {
        core.stopLoading(_context);
      } else {
        _refreshController.refreshCompleted();
      }
    } catch (_) {
      if (!isPulltorefresh) {
        core.stopLoading(_context);
      } else {
        _refreshController.refreshCompleted();
      }
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getPosts(date);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    try {
      if (!isPulltorefresh) {
        core.stopLoading(_context);
      } else {
        _refreshController.refreshCompleted();
      }
    } catch (_) {}

    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        if (response.payload.length == 0) {
          fetchMore = false;
        }
        print("length+++++++++++++++++++++++++++++" +
            response.payload.length.toString());
        setState(() {
          isSelected = false;
          _refreshController.refreshCompleted();
          if (isPaginationCall) {
            posts.addAll(response.payload);
          } else {
            posts = response.payload;
          }
        });
        if (isUserLoggedIn) getUser();
      }
    }
  }

  void getUser() async {
    core.startLoading(_context);
    ResponseUser response;
    try {
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

    try {
      core.stopLoading(_context);
    } catch (_) {}
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        setState(() {
          user = response.payload;
          if (null != response.payload.thumbUrl &&
              !response.payload.thumbUrl.isEmpty) {
            imageUrl = response.payload.thumbUrl;
          }
          if (null != response.payload.isPro) {
            isPro = response.payload.isPro;
            print("isPro++++++++++++" + response.payload.isPro.toString());
          }
        });
      }
    }
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivityAddNewPost(image: pickedFile)),
      );
      getPosts(DateTime.now());
    }
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivityAddNewPost(image: pickedFile)),
      );
      getPosts(DateTime.now());
    }
  }

  InkWell PostListItem(BuildContext context, int index) {
    AlMajlisPost post = posts.elementAt(index);
    bool showExpiry = false;
    String location = " ";
    if (null != post.location) {
      if (null != post.location.city && !post.location.city.isEmpty) {
        location = post.location.city;
      }

      if (null != post.location.country && !post.location.country.isEmpty) {
        if (location.length > 0) {
          location = location + ", " + post.location.country;
        } else
          location = location + post.location.country;
      }
    }
    var image = post.file;
    if (null == post.isLiked) post.isLiked = false;
    print(post.postUser);
    print(post);
    return InkWell(
      onTap: () async {
        if (isUserLoggedIn) {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivitySinglePost(id: post.postId)),
          );
          getPosts(DateTime.now());
        } else {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
          // setState(() {
          //   isUserLoggedIn = core.isUserLoggedIn();
          //   getPosts(DateTime.now());
          // });
        }
      },
      child: Padding(
          padding: EdgeInsets.only(
              top: 4.0, bottom: index == posts.length - 1 ? 100 : 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Constants.COLOR_DARK_GREY,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    border: Border.all(width: 0),
                  ),
                  child: Row(
                    children: <Widget>[
                      post.postUser.isPro
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: 2.0,
                                decoration: BoxDecoration(
                                  color: Constants.COLOR_PRIMARY_TEAL,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Constants.COLOR_PRIMARY_TEAL,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: 2.0,
                              color: Constants.COLOR_DARK_GREY,
                            ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16, left: 12, right: 16),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  null != post.postUser.thumbUrl &&
                                          !post.postUser.thumbUrl.isEmpty
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (isUserLoggedIn) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityProfile(
                                                          userId: post
                                                              .postUser.userId,
                                                        )),
                                              );
                                            } else {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                              // setState(() {
                                              //   isUserLoggedIn =
                                              //       core.isUserLoggedIn();
                                              //   getPosts(DateTime.now());
                                              // });
                                            }
                                          },
                                          child: AlMajlisProfileImageWithStatus(
                                              post.postUser.thumbUrl, 50.0,
                                              isPro: null != post.postUser.isPro
                                                  ? post.postUser.isPro
                                                  : false),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            if (isUserLoggedIn) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityProfile(
                                                          userId: post
                                                              .postUser.userId,
                                                        )),
                                              );
                                            } else {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                              // setState(() {
                                              //   isUserLoggedIn =
                                              //       core.isUserLoggedIn();
                                              //   getPosts(DateTime.now());
                                              // });
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: post.postUser.isPro
                                                    ? Constants
                                                        .COLOR_PRIMARY_TEAL
                                                    : Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                                        ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 8),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          if (isUserLoggedIn) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityProfile(
                                                                            userId:
                                                                                post.postUser.userId,
                                                                          )),
                                                            );
                                                          } else {
                                                            await Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                                            // setState(() {
                                                            //   isUserLoggedIn = core
                                                            //       .isUserLoggedIn();
                                                            //   getPosts(DateTime
                                                            //       .now());
                                                            // });
                                                          }
                                                        },
                                                        child:
                                                            AlMajlisTextViewBold(
                                                          post.postUser
                                                                  .firstName +
                                                              " " +
                                                              post.postUser
                                                                  .lastName,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child:
                                                          AlMajlisTextViewBold(
                                                        timeago
                                                            .format(
                                                                post.createdAt,
                                                                locale:
                                                                    'en_short')
                                                            .toUpperCase(),
                                                        size: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          null != location && !location.isEmpty
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child:
                                                          AlMajlisTextViewMedium(
                                                        location,
                                                        size: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: showExpiry,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 2.0),
                                                            child: Image.asset(
                                                                "drawables/time-01.png",
                                                                height: 8.0),
                                                          ),
                                                          Text(
                                                            "3 hr left",
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color:
                                                                    Colors.red),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 62.0,
                                    ),
                                    Expanded(
                                        child: Linkify(
                                      onOpen: (link) async {
                                        if (await canLaunch(link.url)) {
                                          await launch(link.url);
                                        } else {
                                          throw 'Could not launch $link';
                                        }
                                      },
                                      text: post.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'ProximaNovaRegular',
                                      ),
                                      linkStyle: TextStyle(
                                        color: Constants.COLOR_PRIMARY_TEAL,
                                        fontFamily: 'ProximaNovaRegular',
                                      ),
                                    )

//                                          AlMajlisTextViewRegular(
//                                        post.text,
//                                        size: 14,
//                                      ),
                                        ),
                                  ],
                                ),
                              ),
                              null != image && !image.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // SizedBox(
                                          //   width: 55.0,
                                          // ),
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityPhotoZoom(
                                                              image)),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    // left: 15.0,
                                                    // right: 14.0,
                                                    top: 8.0),
                                                padding: EdgeInsets.only(
                                                    top: 2.0,
                                                    bottom: 2.0,
                                                    left: 2.0,
                                                    right: 2.0),
                                                height: 150.0,
                                                width: 150.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: CachedNetworkImage(
                                                  imageUrl: image,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container();
                                                  },
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator())),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 62.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          if (isUserLoggedIn) {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityReplyToPost(
                                                        post: post,
                                                      )),
                                            );
                                          } else {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                            // setState(() {
                                            //   isUserLoggedIn =
                                            //       core.isUserLoggedIn();
                                            // });
                                          }
                                          getPosts(DateTime.now());
                                        },
                                        child: widegtIconWithCounterText(
                                            "drawables/comment-01.png",
                                            null != post.commentCount
                                                ? post.commentCount.toString()
                                                : "0"),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (isUserLoggedIn) {
                                            post.isLiked
                                                ? decrement(index)
                                                : increment(index);
                                          } else {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                            // setState(() {
                                            //   isUserLoggedIn =
                                            //       core.isUserLoggedIn();
                                            //   getPosts(DateTime.now());
                                            // });
                                          }
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Icon(
                                                      post.isLiked
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: post.isLiked
                                                          ? Colors.red
                                                          : Colors.grey,
                                                      size: 16,
                                                    )),
                                              ),
                                              TextSpan(
                                                  text:
                                                      post.likeCount.toString(),
                                                  style: TextStyle(
                                                      color: post.isLiked
                                                          ? Constants
                                                              .COLOR_PRIMARY_TEAL
                                                          : Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     if (isUserLoggedIn) {
                                      //       scaffoldState.currentState
                                      //           .showBottomSheet((context) =>
                                      //               PostShareBottomSheet(
                                      //                 copyLink: copyLink,
                                      //                 shareLink: shareLink,
                                      //                 sahreToUsers:
                                      //                     shareToUsers,
                                      //                 index: index,
                                      //               ));
                                      //       newShare(post.postId);
                                      //     } else {
                                      //       await Navigator.of(context).push(
                                      //           MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   ActivityLogin())).then((value) => value != null
                                                // ? {
                                                //     Navigator.of(context)
                                                //         .pushReplacement(
                                                //             MaterialPageRoute(
                                                //                 builder:
                                                //                     (context) =>
                                                //                         Home())),
                                                //   }
                                                // : null);
                                          //   setState(() {
                                          //     isUserLoggedIn =
                                          //         core.isUserLoggedIn();
                                          //     getPosts(DateTime.now());
                                          //   });
                                          // }
                                      //   },
                                      //   child: widegtIconWithCounterText(
                                      //       "drawables/upload-01.png",
                                      //       null != post.shareCount
                                      //           ? post.shareCount.toString()
                                      //           : "0"),
                                      // ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (isUserLoggedIn) {
                                              if (post.postUser.userId ==
                                                  core
                                                      .getCurrentUser()
                                                      .userId) {
                                                scaffoldState.currentState
                                                    .showBottomSheet((context) =>
                                                        BottomSheetOperations(
                                                            editPost,
                                                            deletePostThroughDialog,
                                                            index));
                                              } else {
                                                scaffoldState.currentState
                                                    .showBottomSheet((context) =>
                                                        ReportPostBottomSheet(
                                                          reportClicked: () {
                                                            reportClicked(
                                                                index);
                                                          },
                                                        ));
                                              }
                                            } else {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityLogin())).then((value) => value != null
                                                ? {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                  }
                                                : null);
                                              // setState(() {
                                              //   isUserLoggedIn =
                                              //       core.isUserLoggedIn();
                                              //   getPosts(DateTime.now());
                                              // });
                                            }
                                          },
                                          child: AlMajlisImageIcons(
                                            "drawables/More_grey-01.png",
                                            iconHeight: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 19),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipPath(
                    child: Container(
                      width: 30,
                      height: 20,
                      color: Constants.COLOR_DARK_GREY,
                    ),
                    clipper: MyCustomClipper(),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: post.postUser.isPro
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 4, bottom: 5, left: 1),
                          child: Container(
                            width: 2.0,
//                      height: MediaQuery.of(context).size.height / 5.6,
                            decoration: BoxDecoration(
                              color: Constants.COLOR_PRIMARY_TEAL,
                              boxShadow: [
                                BoxShadow(
                                  color: Constants.COLOR_PRIMARY_TEAL,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: Constants.COLOR_DARK_GREY,
                        ),
                ),
              ],
            ),
          )
//        Column(
//          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(
//                  color: Constants.COLOR_DARK_GREY,
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(10.0),
//                      topRight: Radius.circular(10.0),
//                      bottomRight: Radius.circular(10.0)),
//              ),
//              width: double.infinity,
//              child: Stack(
//                children: <Widget>[
//                  Positioned(
//                    top: 0,
//                    bottom: 0,
//                    left: 0,
//                    child: post.postUser.isPro
//                        ? Padding(
//                            padding: const EdgeInsets.only(top: 6.0, right: 4),
//                            child: Container(
//                              width: 2.0,
////                      height: MediaQuery.of(context).size.height / 5.6,
//                              decoration: BoxDecoration(
//                                color: Constants.COLOR_PRIMARY_TEAL,
//                                boxShadow: [
//                                  BoxShadow(
//                                    color: Constants.COLOR_PRIMARY_TEAL,
//                                    blurRadius: 2.0,
//                                    spreadRadius: 0.0,
//                                    offset: Offset(2.0,
//                                        2.0), // shadow direction: bottom right
//                                  )
//                                ],
//                              ),
//                            ),
//                          )
//                        : Container(
//                            color: Constants.COLOR_DARK_GREY,
//                          ),
//                  ),
//                  Row(
//                    children: <Widget>[
//                      post.postUser.isPro
//                          ? Padding(
//                              padding: const EdgeInsets.only(top: 8.0),
//                              child: Container(
//                                width: 2.0,
//                                decoration: BoxDecoration(
//                                  color: Constants.COLOR_PRIMARY_TEAL,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Constants.COLOR_PRIMARY_TEAL,
//                                      blurRadius: 2.0,
//                                      spreadRadius: 0.0,
//                                      offset: Offset(2.0,
//                                          2.0), // shadow direction: bottom right
//                                    )
//                                  ],
//                                ),
//                              ),
//                            )
//                          : Container(
//                              width: 2.0,
//                              color: Constants.COLOR_DARK_GREY,
//                            ),
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(top:16, bottom:16, left: 12, right:16),
//                          child: Column(
//                            children: <Widget>[
//                              Row(
//                                children: <Widget>[
//                                  null != post.postUser.thumbUrl &&
//                                          !post.postUser.thumbUrl.isEmpty
//                                      ? GestureDetector(
//                                          onTap: () async {
//                                            if (isUserLoggedIn) {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                    builder: (context) =>
//                                                        ActivityProfile(
//                                                          userId: post
//                                                              .postUser.userId,
//                                                        )),
//                                              );
//                                            } else {
//                                              await Navigator.of(context).push(
//                                                  MaterialPageRoute(
//                                                      builder: (context) =>
//                                                          ActivityLogin()));
//                                              setState(() {
//                                                isUserLoggedIn =
//                                                    core.isUserLoggedIn();
//                                                getPosts(DateTime.now());
//                                              });
//                                            }
//                                          },
//                                          child: AlMajlisProfileImageWithStatus(
//                                              post.postUser.thumbUrl, 50.0,
//                                              isPro: null != post.postUser.isPro
//                                                  ? post.postUser.isPro
//                                                  : false),
//                                        )
//                                      : GestureDetector(
//                                          onTap: () async {
//                                            if (isUserLoggedIn) {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                    builder: (context) =>
//                                                        ActivityProfile(
//                                                          userId: post
//                                                              .postUser.userId,
//                                                        )),
//                                              );
//                                            } else {
//                                              await Navigator.of(context).push(
//                                                  MaterialPageRoute(
//                                                      builder: (context) =>
//                                                          ActivityLogin()));
//                                              setState(() {
//                                                isUserLoggedIn =
//                                                    core.isUserLoggedIn();
//                                                getPosts(DateTime.now());
//                                              });
//                                            }
//                                          },
//                                          child: Container(
//                                            height: 50,
//                                            width: 50,
//                                            decoration: BoxDecoration(
//                                                shape: BoxShape.circle,
//                                                color: post.postUser.isPro
//                                                    ? Constants
//                                                        .COLOR_PRIMARY_TEAL
//                                                    : Colors.white),
//                                            child: Padding(
//                                              padding:
//                                                  const EdgeInsets.all(4.0),
//                                              child: Container(
//                                                decoration: BoxDecoration(
//                                                    shape: BoxShape.circle,
//                                                    gradient: LinearGradient(
//                                                        colors: [
//                                                          Colors.purple,
//                                                          Colors.teal
//                                                        ])),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                  Expanded(
//                                    child: Padding(
//                                      padding: const EdgeInsets.only(
//                                          left:12, right:8),
//                                      child: Column(
//                                        children: <Widget>[
//                                          Row(
//                                            children: <Widget>[
//                                              Expanded(
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Expanded(
//                                                      child: GestureDetector(
//                                                        onTap: () async {
//                                                          if (isUserLoggedIn) {
//                                                            Navigator.push(
//                                                              context,
//                                                              MaterialPageRoute(
//                                                                  builder:
//                                                                      (context) =>
//                                                                          ActivityProfile(
//                                                                            userId:
//                                                                                post.postUser.userId,
//                                                                          )),
//                                                            );
//                                                          } else {
//                                                            await Navigator.of(
//                                                                    context)
//                                                                .push(MaterialPageRoute(
//                                                                    builder:
//                                                                        (context) =>
//                                                                            ActivityLogin()));
//                                                            setState(() {
//                                                              isUserLoggedIn = core
//                                                                  .isUserLoggedIn();
//                                                              getPosts(DateTime
//                                                                  .now());
//                                                            });
//                                                          }
//                                                        },
//                                                        child:
//                                                            AlMajlisTextViewBold(
//                                                          post.postUser
//                                                                  .firstName +
//                                                              " " +
//                                                              post.postUser
//                                                                  .lastName,
//                                                          size: 16,
//                                                        ),
//                                                      ),
//                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 4.0),
//                                                      child:
//                                                          AlMajlisTextViewRegular(
//                                                        timeago.format(
//                                                            post.createdAt),
//                                                        size: 12,
//                                                        color: Colors.grey,
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                          Row(
//                                            children: <Widget>[
//                                              Expanded(
//                                                child: AlMajlisTextViewMedium(
//                                                  location,
//                                                  size: 12,
//                                                  color: Colors.grey,
//                                                ),
//                                              ),
//                                              Visibility(
//                                                visible: showExpiry,
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 10.0,
//                                                              right: 2.0),
//                                                      child: Image.asset(
//                                                          "drawables/time-01.png",
//                                                          height: 8.0),
//                                                    ),
//                                                    Text(
//                                                      "3 hr left",
//                                                      style: TextStyle(
//                                                          fontSize: 12.0,
//                                                          color: Colors.red),
//                                                    )
//                                                  ],
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  SizedBox(
//                                    width: 62.0,
//                                  ),
//                                  Expanded(
//                                    child: AlMajlisTextViewRegular(
//                                      post.text,
//                                      size: 14,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Visibility(
//                                visible: isUserLoggedIn,
//                                child: Padding(
//                                  padding: const EdgeInsets.only(top: 8.0),
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(left:62.0),
//                                    child: Row(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        GestureDetector(
//                                          onTap: () {},
//                                          child: widegtIconWithCounterText(
//                                              "drawables/comment-01.png",
//                                              null != post.commentCount
//                                                  ? post.commentCount.toString()
//                                                  : "0"),
//                                        ),
//                                        InkWell(
//                                          onTap: () {
//                                            post.isLiked
//                                                ? decrement(index)
//                                                : increment(index);
//                                          },
//                                          child: RichText(
//                                            text: TextSpan(
//                                              children: [
//                                                WidgetSpan(
//                                                  child: Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              right: 5.0),
//                                                      child: Icon(
//                                                        post.isLiked
//                                                            ? Icons.favorite
//                                                            : Icons
//                                                                .favorite_border,
//                                                        color: post.isLiked
//                                                            ? Colors.red
//                                                            : Colors.grey,
//                                                        size: 16,
//                                                      )),
//                                                ),
//                                                TextSpan(
//                                                    text: post.likeCount
//                                                        .toString(),
//                                                    style: TextStyle(
//                                                        color: post.isLiked
//                                                            ? Constants
//                                                                .COLOR_PRIMARY_TEAL
//                                                            : Colors.grey)),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        GestureDetector(
//                                          onTap: () async {
//                                            if (isUserLoggedIn) {
//                                              scaffoldState.currentState
//                                                  .showBottomSheet((context) =>
//                                                      PostShareBottomSheet(
//                                                        copyLink: copyLink,
//                                                        shareLink: shareLink,
//                                                        sahreToUsers:
//                                                            shareToUsers,
//                                                        index: index,
//                                                      ));
//                                              newShare(post.postId);
//                                            } else {
//                                              await Navigator.of(context).push(
//                                                  MaterialPageRoute(
//                                                      builder: (context) =>
//                                                          ActivityLogin()));
//                                              setState(() {
//                                                isUserLoggedIn =
//                                                    core.isUserLoggedIn();
//                                                getPosts(DateTime.now());
//                                              });
//                                            }
//                                          },
//                                          child: widegtIconWithCounterText(
//                                              "drawables/upload-01.png",
//                                              null != post.shareCount
//                                                  ? post.shareCount.toString()
//                                                  : "0"),
//                                        ),
//                                        Padding(
//                                          padding:
//                                              const EdgeInsets.only(right: 8.0),
//                                          child: GestureDetector(
//                                            onTap: () async {
//                                              if (isUserLoggedIn) {
//                                                if (post.postUser.userId ==
//                                                    core
//                                                        .getCurrentUser()
//                                                        .userId) {
//                                                  scaffoldState.currentState
//                                                      .showBottomSheet((context) =>
//                                                          BottomSheetOperations(
//                                                              editPost,
//                                                              deletePost,
//                                                              index));
//                                                } else {
//                                                  scaffoldState.currentState
//                                                      .showBottomSheet((context) =>
//                                                          ReportPostBottomSheet(
//                                                            reportClicked: () {
//                                                              reportClicked(
//                                                                  index);
//                                                            },
//                                                          ));
//                                                }
//                                              } else {
//                                                await Navigator.of(context)
//                                                    .push(MaterialPageRoute(
//                                                        builder: (context) =>
//                                                            ActivityLogin()));
//                                                setState(() {
//                                                  isUserLoggedIn =
//                                                      core.isUserLoggedIn();
//                                                  getPosts(DateTime.now());
//                                                });
//                                              }
//                                            },
//                                            child: AlMajlisImageIcons(
//                                              "drawables/More_grey-01.png",
//                                              iconHeight: 16,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//            Row(
//              children: <Widget>[
//                ClipPath(
//                  child: Stack(
//                    children: <Widget>[
//                      Container(
//                        width: 30,
//                        height: 20,
//                        color: Constants.COLOR_DARK_GREY,
//                      ),
//                      post.postUser.isPro
//                          ? Container(
//                              width: 2.0,
//                              height: 20,
//                              decoration: BoxDecoration(
//                                color: Constants.COLOR_PRIMARY_TEAL,
//                                boxShadow: [
//                                  BoxShadow(
//                                    color: Constants.COLOR_PRIMARY_TEAL,
//                                    blurRadius: 2.0,
//                                    spreadRadius: 0.0,
//                                    offset: Offset(2.0,
//                                        2.0), // shadow direction: bottom right
//                                  )
//                                ],
//                              ),
//                            )
//                          : Container()
//                    ],
//                  ),
//                  clipper: MyCustomClipper(),
//                ),
//              ],
//            )
//          ],
//        ),
          ),
    );
  }

  editPost(index) async {
    Navigator.pop(_context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ActivityEditPost(
                postId: posts.elementAt(index).postId,
              )),
    );
    getPosts(DateTime.now());
  }

  deletePostThroughDialog(int index) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: AlMajlisTextViewBold(
                    "Do you want to delete post ?",
                    color: Constants.COLOR_PRIMARY_TEAL,
                    align: TextAlign.center,
                    size: 16,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deletePost(index);
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "YES",
                  style: TextStyle(color: Colors.white),
                ),
                color: Constants.COLOR_PRIMARY_TEAL,
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "NO",
                  style: TextStyle(color: Colors.white),
                ),
                color: Constants.COLOR_PRIMARY_TEAL,
              ),
            ],
          );
        });
  }

  deletePost(index) async {
    //Navigator.pop(_context);
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.deletePost(posts.elementAt(index).postId);
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
                    deletePost(posts.elementAt(index).postId);
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
        getPosts(DateTime.now());
      }
    }
  }

  void reportClicked(index) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return DialogReport(0);
        }).then((value) {
      reportPost(index, Constants.reportReasons.elementAt(value));
    });
  }

  void reportPost(index, String reason) async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.reportPost(posts.elementAt(index).postId, reason);
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
                    reportPost(posts.elementAt(index).postId, reason);
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
            msg: "Post Has been reported",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
      }
    }
  }

  Container shareLinkWidgetRow(
      BuildContext context, IconData iconName, String name) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Icon(
            //TODO:change icons for both tile.
            iconName,
            color: Colors.white,
            size: 22,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: AlMajlisTextViewSemiBold(
              name,
              size: 14,
            ),
          ))
        ],
      ),
    );
  }

  Expanded showTotalCards(String imageName, String totalNumbers, String name) {
    return Expanded(
      child: Container(
        height: 60.0,
        margin: EdgeInsets.only(top: 8.0, right: 12.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Constants.COLOR_DARK_GREY,
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imageName,
              height: 26.0,
            ),
            SizedBox(
              width: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  AlMajlisTextViewBold(totalNumbers),
                  AlMajlisTextViewBold(name)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  RichText widegtIconWithCounterText(String iconName, String counter) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Image.asset(
                iconName,
                height: 16,
              ),
            ),
          ),
          TextSpan(text: counter, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void decrement(index) async {
    setState(() {
      posts.elementAt(index).isLiked = false;
      if (null != posts.elementAt(index).likeCount)
        posts.elementAt(index).likeCount--;
    });
    AlMajlisPost post = posts.elementAt(index);
    ResponseOk response;
    try {
      response = await core.dislikePost(post.postId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    } catch (_) {
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    decrement(index);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    if (core.systemCanHandel(response)) {
      setState(() {
        posts.elementAt(index).isLiked = true;
        if (null != posts.elementAt(index).likeCount > 1)
          posts.elementAt(index).likeCount++;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          posts.elementAt(index).isLiked = true;
          if (null != posts.elementAt(index).likeCount)
            posts.elementAt(index).likeCount++;
        });
      }
    }
  }

  void increment(int index) async {
    setState(() {
      posts.elementAt(index).isLiked = true;
      if (null != posts.elementAt(index).likeCount)
        posts.elementAt(index).likeCount++;
      else
        posts.elementAt(index).likeCount = 1;
    });
    AlMajlisPost post = posts.elementAt(index);
    ResponseOk response;
    try {
      response = await core.likePost(post.postId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    } catch (_) {
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    increment(index);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    if (core.systemCanHandel(response)) {
      setState(() {
        posts.elementAt(index).isLiked = false;
        if (posts.elementAt(index).likeCount > 1)
          posts.elementAt(index).likeCount--;
        else
          posts.elementAt(index).likeCount = 0;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          posts.elementAt(index).isLiked = false;
          if (posts.elementAt(index).likeCount > 1)
            posts.elementAt(index).likeCount--;
          else
            posts.elementAt(index).likeCount = 0;
        });
      }
    }
  }

  void sendLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;
    if (isUserLoggedIn) {
      await core.updateLocation(
          position.latitude.toString(), position.longitude.toString());
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getPosts(DateTime.now());
    sendLocation();
    if (isUserLoggedIn) {
      getUser();

      if (PushRegisterService().fromNotification) {
        PushRegisterService().fromNotification = false;
        Map<String, dynamic> data;
        if (Platform.isIOS) {
          data = PushRegisterService().message;
          if (data['type'] == "1") {
            if (null != data['post']) {
              var postData = data['post'];
              Map<String, dynamic> temp = jsonDecode(postData);
              AlMajlisPost post = AlMajlisPost.fromMap(temp);
              print(post);
              if (null != post.postId) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivitySinglePost(
                        id: post.postId,
                      ));
                });
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
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivitySinglePost(
                        id: comment.post.postId,
                      ));
                });
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
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(
                      ActivityVideoCallOperationsScreen(booking.id));
                });
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
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivityUserChat(
                        myUserId: core.getCurrentUser().userId,
                        otherPersonUserId: user.userId,
                      ));
                });
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
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivityProfile(
                        userId: user.userId,
                      ));
                });
              }
            }
          }
        } else {
          if (PushRegisterService().message['data']['type'] == "1") {
            if (null != PushRegisterService().message['data']['post']) {
              var postData = PushRegisterService().message['data']['post'];
              Map<String, dynamic> temp = jsonDecode(postData);
              AlMajlisPost post = AlMajlisPost.fromMap(temp);
              print(post);
              if (null != post.postId) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivitySinglePost(
                        id: post.postId,
                      ));
                });
              }
            }
          }
          if (PushRegisterService().message['data']['type'] == "2") {
            if (null != PushRegisterService().message['data']['comment']) {
              var commentData =
                  PushRegisterService().message['data']['comment'];
              Map<String, dynamic> temp = jsonDecode(commentData);
              AlMajlisComment comment = AlMajlisComment.fromMap(temp);
              print(comment.post.postId);
              if (null != comment.post.postId) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivitySinglePost(
                        id: comment.post.postId,
                      ));
                });
              }
            }
          }
          if (PushRegisterService().message['data']['type'] == "5") {
            if (null != PushRegisterService().message['data']['booking']) {
              var bookingData =
                  PushRegisterService().message['data']['booking'];
              Map<String, dynamic> temp = jsonDecode(bookingData);
              Booking booking = Booking.fromMap(temp);
              print(booking.id);
              if (null != booking.id) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(
                      ActivityVideoCallOperationsScreen(booking.id));
                });
              }
            }
          }
          if (PushRegisterService().message['data']['type'] == "9") {
            if (null != PushRegisterService().message['data']['message_by']) {
              var userData =
                  PushRegisterService().message['data']['message_by'];
              Map<String, dynamic> temp = jsonDecode(userData);
              User user = User.fromMap(temp);
              print(user.userId);
              if (null != user.userId) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivityUserChat(
                        myUserId: core.getCurrentUser().userId,
                        otherPersonUserId: user.userId,
                      ));
                });
              }
            }
          }
          if (PushRegisterService().message['data']['type'] == "10") {
            if (null != PushRegisterService().message['data']['forwarded_by']) {
              var userData =
                  PushRegisterService().message['data']['forwarded_by'];
              Map<String, dynamic> temp = jsonDecode(userData);
              User user = User.fromMap(temp);
              print(user.userId);
              if (null != user.userId) {
                Future.delayed(Duration(seconds: 2), () {
                  core.getIt<NavigationService>().navigateTo(ActivityProfile(
                        userId: user.userId,
                      ));
                });
              }
            }
          }
        }
//      Future.delayed(Duration(seconds: 2), () {
//        Navigator.of(context).pushAndRemoveUntil(
//            MaterialPageRoute(builder: (context) => ActivityNotificaton()),
//                (Route<dynamic> route) => false);
//      });
      }
    }
  }

  initDynamicLinks() async {
    print("in dynamic links");
    var linkUserId;
    var linkPostId;
    await Future.delayed(Duration(seconds: 3));
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    print("data" + data.toString());
    var deepLink = data?.link;
    print("deeplink" + deepLink.toString());
    if (null != deepLink) {
      final queryParams = deepLink.queryParameters;
      if (queryParams.length > 0) {
        linkUserId = queryParams['userId'];
        linkPostId = queryParams['postId'];
      }
      print("user" + linkUserId.toString());
      print("post" + linkPostId.toString());
      if (isUserLoggedIn) {
        if (null != linkUserId) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityProfile(
                      userId: linkUserId,
                    )),
          );
        }
        if (null != linkPostId) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivitySinglePost(
                      id: linkPostId,
                    )),
          );
        }
      }
    }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      var deepLink = dynamicLink?.link;
      print('DynamicLinks onLink $deepLink');
      if (null != deepLink) {
        final queryParams = deepLink.queryParameters;
        if (queryParams.length > 0) {
          linkUserId = queryParams['userId'];
          linkPostId = queryParams['postId'];
        }
        print("user" + linkUserId.toString());
        print("post" + linkPostId.toString());
        if (isUserLoggedIn) {
          if (null != linkUserId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActivityProfile(
                        userId: linkUserId,
                      )),
            );
          }
          if (null != linkPostId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActivitySinglePost(
                        id: linkPostId,
                      )),
            );
          }
        }
      }
    }, onError: (e) async {
      print('DynamicLinks onError $e');
    });
  }
}

class AlMajlisRoundIconButton extends StatelessWidget {
  var icon;
  AlMajlisRoundIconButton(
    this.icon, {
    Key key,
    @required this.isSelected,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Constants.COLOR_PRIMARY_TEAL
                : Constants.COLOR_DARK_GREY),
        child: Center(
          child: Container(
            child: AlMajlisImageIcons(
              icon,
              iconHeight: 20,
            ),
          ),
        ),
      ),
    );
  }
}
