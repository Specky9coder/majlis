import 'dart:async';
import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivitySearch.dart';
import 'package:almajlis/core/constants/countryStateConstant.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';
import 'package:almajlis/core/wrappers/AlMajlisCountries.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewWithVerified.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class ActivityDiscover extends StatefulWidget {
  @override
  _ActivityDiscoverState createState() => _ActivityDiscoverState();
}

class _ActivityDiscoverState extends ActivityStateBase<ActivityDiscover> {
  bool isSelected = false;
  bool discoveryClosed = true;
  bool toogleValue = false;
  bool toogleValue1 = false;
  bool isSearchBtnClicked = false;
  TextEditingController searchController = TextEditingController();
  List<User> proUsers = List();
  List<User> nearMeUsers = List();
  List<User> userList = List();
  BuildContext _context;
  String lat;
  String lng;
  bool isPermissionGranted;
  int selectedDistance = 0;
  String selectedCountry;
  AlMajlisCountries countries;
  List<String> countryList = List();
  List<int> distanceList = [10, 15, 20, 25, 30, 50, 100];
  int totalPosts = 0;
  int totalUsers = 0;
  List<User> serachUsers = List();
  Timer searchOnStoppedTyping;
  bool showDistanceFilters = false;
  bool fetchMore = true;
  bool fetchMoreProUsers = true;
  bool hasRemovedSelf = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countries = AlMajlisCountries.fromMap(countryState);
    for (int index = 0; index < countries.countries.length; index++) {
      countryList.add(countries.countries.elementAt(index).name);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    print("length++++++++++++++++++++++++++++++" + userList.length.toString());
    return AlMajlisBackground(
      Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: AlMajlisRoundIconButton(
                        "drawables/settings.png",
                        isSelected: isSelected,
                      ),
                      onTap: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                    ),
                    GestureDetector(
                      child: AlMajlisRoundIconButton(
                          "drawables/searchwhite.png",
                          isSelected: false),
                      onTap: () {
                        setState(() {
                          // isSearchBtnClicked = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivitySearch()),
                          );
                        });
                      },
                    )
                  ],
                ),
                isSelected
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      color: Constants.COLOR_DARK_TEAL,
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
                                    fetchMore = true;
                                    userList = List();
                                    hasRemovedSelf = false;
                                    getUserList(
                                        lat,
                                        lng,
                                        selectedDistance == 0
                                            ? null
                                            : (selectedDistance * 1000)
                                                .toString(),
                                        selectedCountry,
                                        toogleValue,
                                        0);
                                    getProUsers(
                                        lat,
                                        lng,
                                        selectedDistance == 0
                                            ? null
                                            : (selectedDistance * 1000)
                                                .toString(),
                                        selectedCountry);
                                  },
                                  activeColor: Colors.green,
                                  inactiveTrackColor:
                                      Constants.COLOR_PRIMARY_GREY,
                                )
                              ],
                            ),
                            Divider(
                              color: Constants.COLOR_PRIMARY_GREY,
                              thickness: 2.5,
                            ),
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
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    height: 40,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: countryList.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          bool isCountySelected = false;
                                          if (selectedCountry ==
                                              countryList.elementAt(index)) {
                                            isCountySelected = true;
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: GestureDetector(
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Colors.white),
                                                  borderRadius: BorderRadius.all(
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
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            AlMajlisTextViewMedium(
                                                          countryList
                                                              .elementAt(index),
                                                          align:
                                                              TextAlign.center,
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
                                                          .elementAt(index)) {
                                                    selectedCountry = null;
                                                  } else {
                                                    selectedCountry =
                                                        countryList
                                                            .elementAt(index);
                                                  }
                                                });
                                                fetchMore = true;
                                                userList = List();
                                                hasRemovedSelf = false;
                                                getUserList(
                                                    lat,
                                                    lng,
                                                    selectedDistance == 0
                                                        ? null
                                                        : (selectedDistance *
                                                                1000)
                                                            .toString(),
                                                    selectedCountry,
                                                    toogleValue,
                                                    0);
                                                getProUsers(
                                                    lat,
                                                    lng,
                                                    selectedDistance == 0
                                                        ? null
                                                        : (selectedDistance *
                                                                1000)
                                                            .toString(),
                                                    selectedCountry);
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Constants.COLOR_PRIMARY_GREY,
                              thickness: 2.5,
                            ),
                            Visibility(
                              visible: showDistanceFilters,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AlMajlisTextViewMedium(
                                    "Distance",
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 40,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: distanceList.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            bool isDistanceSelected = false;
                                            if (selectedDistance ==
                                                distanceList.elementAt(index)) {
                                              isDistanceSelected = true;
                                            }

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: GestureDetector(
                                                child: Container(
                                                  width: 75,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    borderRadius: BorderRadius.all(
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
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              AlMajlisTextViewMedium(
                                                            distanceList
                                                                    .elementAt(
                                                                        index)
                                                                    .toString() +
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
                                                            .elementAt(index)) {
                                                      selectedDistance = 0;
                                                    } else {
                                                      selectedDistance =
                                                          distanceList
                                                              .elementAt(index);
                                                    }
                                                  });
                                                  fetchMore = true;
                                                  userList = List();
                                                  hasRemovedSelf = false;
                                                  getUserList(
                                                      lat,
                                                      lng,
                                                      selectedDistance == 0
                                                          ? null
                                                          : (selectedDistance *
                                                                  1000)
                                                              .toString(),
                                                      selectedCountry,
                                                      toogleValue,
                                                      0);
                                                  getProUsers(
                                                      lat,
                                                      lng,
                                                      selectedDistance == 0
                                                          ? null
                                                          : (selectedDistance *
                                                                  1000)
                                                              .toString(),
                                                      selectedCountry);
                                                  getNearMeUsers(lat, lng);
                                                },
                                              ),
                                            );
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            AlMajlisTextViewBold(
                              "Discover",
                              size: 32,
                            ),
                            discoveryClosed
                                ? GestureDetector(
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        discoveryClosed = !discoveryClosed;
                                      });
                                    },
                                  )
                                : GestureDetector(
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        discoveryClosed = !discoveryClosed;
                                      });
                                    },
                                  )
                          ],
                        ),
                      ),
                Visibility(
                  visible: !discoveryClosed,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        showTotalCards("drawables/contact.png",
                            totalUsers.toString(), "TOTAL USERS"),
                        showTotalCards("drawables/Mask Group 120.png",
                            totalPosts.toString(), "TOTAL POSTS")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: userList.length + 2,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (index == 0) {
                          if (proUsers.length > 0) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: AlMajlisTextViewBold(
                                        "Pro Users",
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    height: 150,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: proUsers.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          if (index == proUsers.length - 2) {
                                            if (fetchMoreProUsers) {
                                              getProUsers(
                                                  lat,
                                                  lng,
                                                  selectedDistance == 0
                                                      ? null
                                                      : (selectedDistance *
                                                              1000)
                                                          .toString(),
                                                  selectedCountry,
                                                  isPaginationCall: true);
                                            }
//                                                getProUsers(null, null, null, null, isPaginationCall: true);
                                          }
                                          String proname = "";
                                          if (null !=
                                              proUsers
                                                  .elementAt(index)
                                                  .firstName) {
                                            proname = proUsers
                                                    .elementAt(index)
                                                    .firstName +
                                                " ";
                                          }
                                          if (null !=
                                              proUsers
                                                  .elementAt(index)
                                                  .lastName) {
                                            proname += proUsers
                                                .elementAt(index)
                                                .lastName;
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0, top: 8, left: 4),
                                            child: Container(
                                              width: 70,
                                              child: Column(
                                                children: <Widget>[
                                                  null !=
                                                              proUsers
                                                                  .elementAt(
                                                                      index)
                                                                  .thumbUrl &&
                                                          !proUsers
                                                              .elementAt(index)
                                                              .thumbUrl
                                                              .isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityProfile(
                                                                            userId:
                                                                                proUsers.elementAt(index).userId,
                                                                          )),
                                                            );
                                                          },
                                                          child:
                                                              AlMajlisProfileImageWithStatus(
                                                            proUsers
                                                                .elementAt(
                                                                    index)
                                                                .thumbUrl,
                                                            70.0,
                                                            isPro: proUsers
                                                                .elementAt(
                                                                    index)
                                                                .isPro,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityProfile(
                                                                            userId:
                                                                                proUsers.elementAt(index).userId,
                                                                          )),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 70,
                                                            width: 70,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: proUsers
                                                                        .elementAt(
                                                                            index)
                                                                        .isPro
                                                                    ? Constants
                                                                        .COLOR_PRIMARY_TEAL
                                                                    : Colors
                                                                        .white),
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
                                                                          Colors
                                                                              .teal
                                                                        ])),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ActivityProfile(
                                                                              userId: proUsers.elementAt(index).userId,
                                                                            )),
                                                              );
                                                            },
                                                            child:
                                                                AlMajlisTextViewSemiBold(
                                                              proname,
                                                              align: TextAlign
                                                                  .center,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }

                        if (index == 1) {
                          if (nearMeUsers.length > 0) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: AlMajlisTextViewBold(
                                        "Near me",
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    height: 150,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: nearMeUsers.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          String nearMeUser = "";
                                          if (null !=
                                              nearMeUsers
                                                  .elementAt(index)
                                                  .firstName) {
                                            nearMeUser = nearMeUsers
                                                    .elementAt(index)
                                                    .firstName +
                                                " ";
                                          }
                                          if (null !=
                                              nearMeUsers
                                                  .elementAt(index)
                                                  .lastName) {
                                            nearMeUser += nearMeUsers
                                                .elementAt(index)
                                                .lastName;
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0, top: 8, left: 4),
                                            child: Container(
                                              width: 70,
                                              child: Column(
                                                children: <Widget>[
                                                  null !=
                                                              nearMeUsers
                                                                  .elementAt(
                                                                      index)
                                                                  .thumbUrl &&
                                                          !nearMeUsers
                                                              .elementAt(index)
                                                              .thumbUrl
                                                              .isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityProfile(
                                                                            userId:
                                                                                nearMeUsers.elementAt(index).userId,
                                                                          )),
                                                            );
                                                          },
                                                          child:
                                                              AlMajlisProfileImageWithStatus(
                                                            nearMeUsers
                                                                .elementAt(
                                                                    index)
                                                                .thumbUrl,
                                                            70.0,
                                                            isPro: nearMeUsers
                                                                .elementAt(
                                                                    index)
                                                                .isPro,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityProfile(
                                                                            userId:
                                                                                nearMeUsers.elementAt(index).userId,
                                                                          )),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 70,
                                                            width: 70,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: nearMeUsers
                                                                        .elementAt(
                                                                            index)
                                                                        .isPro
                                                                    ? Constants
                                                                        .COLOR_PRIMARY_TEAL
                                                                    : Colors
                                                                        .white),
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
                                                                          Colors
                                                                              .teal
                                                                        ])),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ActivityProfile(
                                                                              userId: nearMeUsers.elementAt(index).userId,
                                                                            )),
                                                              );
                                                            },
                                                            child:
                                                                AlMajlisTextViewSemiBold(
                                                              nearMeUser,
                                                              align: TextAlign
                                                                  .center,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }

                        if (index == userList.length) {
                          if (fetchMore) {
                            Future.delayed(Duration(seconds: 1), () {
                              getUserList(
                                  lat,
                                  lng,
                                  selectedDistance == 0
                                      ? null
                                      : (selectedDistance * 1000).toString(),
                                  selectedCountry,
                                  toogleValue,
                                  hasRemovedSelf
                                      ? userList.length + 1
                                      : userList.length);
                            });
                          }
                        }
                        String name = "";
                        if (null != userList.elementAt(index - 2).firstName) {
                          name = userList.elementAt(index - 2).firstName + " ";
                        }
                        if (null != userList.elementAt(index - 2).lastName) {
                          name += userList.elementAt(index - 2).lastName;
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == userList.length + 1 ? 100 : 0),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                index - 2 == 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: AlMajlisTextViewBold(
                                                "All",
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Row(
                                  children: <Widget>[
                                    null !=
                                                userList
                                                    .elementAt(index - 2)
                                                    .thumbUrl &&
                                            !userList
                                                .elementAt(index - 2)
                                                .thumbUrl
                                                .isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityProfile(
                                                            userId: userList
                                                                .elementAt(
                                                                    index - 2)
                                                                .userId,
                                                          )),
                                                );
                                                fetchMore = true;
                                                hasRemovedSelf = false;
                                                userList = List();
                                                getUserList(
                                                    lat,
                                                    lng,
                                                    selectedDistance == 0
                                                        ? null
                                                        : (selectedDistance *
                                                                1000)
                                                            .toString(),
                                                    selectedCountry,
                                                    toogleValue,
                                                    0);
                                              },
                                              child:
                                                  AlMajlisProfileImageWithStatus(
                                                userList
                                                    .elementAt(index - 2)
                                                    .thumbUrl,
                                                70.0,
                                                isPro: userList
                                                    .elementAt(index - 2)
                                                    .isPro,
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivityProfile(
                                                          userId: userList
                                                              .elementAt(
                                                                  index - 2)
                                                              .userId,
                                                        )),
                                              );
                                              fetchMore = true;
                                              hasRemovedSelf = false;
                                              userList = List();
                                              getUserList(
                                                  lat,
                                                  lng,
                                                  selectedDistance == 0
                                                      ? null
                                                      : (selectedDistance *
                                                              1000)
                                                          .toString(),
                                                  selectedCountry,
                                                  toogleValue,
                                                  0);
                                            },
                                            child: Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: userList
                                                          .elementAt(index - 2)
                                                          .isPro
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ActivityProfile(
                                                                  userId: userList
                                                                      .elementAt(
                                                                          index -
                                                                              2)
                                                                      .userId,
                                                                )),
                                                      );
                                                      fetchMore = true;
                                                      hasRemovedSelf = false;
                                                      userList = List();
                                                      getUserList(
                                                          lat,
                                                          lng,
                                                          selectedDistance == 0
                                                              ? null
                                                              : (selectedDistance *
                                                                      1000)
                                                                  .toString(),
                                                          selectedCountry,
                                                          toogleValue,
                                                          0);
                                                    },
                                                    child: AlMajlisTextViewBold(
                                                      name,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
//                                                Container(
//                                                  decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        width: 1.0,
//                                                        color: Colors.white),
//                                                    borderRadius: BorderRadius.all(
//                                                        Radius.circular(
//                                                            5.0) //         <--- border radius here
//                                                        ),
//                                                    color: Colors.transparent,
//                                                  ),
//                                                  child: Padding(
//                                                    padding:
//                                                        const EdgeInsets.all(2.0),
//                                                    child: AlMajlisTextViewBold(
//                                                        "UPDATED"),
//                                                  ),
//                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: AlMajlisTextViewMedium(
                                                    null !=
                                                            userList
                                                                .elementAt(
                                                                    index - 2)
                                                                .occupation
                                                        ? userList
                                                            .elementAt(
                                                                index - 2)
                                                            .occupation
                                                        : "",
                                                    size: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: AlMajlisTextViewMedium(
                                                    null !=
                                                            userList
                                                                .elementAt(
                                                                    index - 2)
                                                                .country
                                                        ? userList
                                                            .elementAt(
                                                                index - 2)
                                                            .country
                                                        : "",
                                                    size: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
//                                AlMajlisButton(
//                                  null,
//                                  Constants.TEAL,
//                                  () {},
//                                  icon: Image.asset(
//                                      "drawables/Add_contact-01.png"),
//                                )

                                    GestureDetector(
                                      onTap: () {
                                        userList
                                                .elementAt(index - 2)
                                                .isFollowing
                                            ? removeConnection(index - 2)
                                            : addConnection(index - 2);
                                      },
                                      child: Image.asset(
                                        !userList
                                                .elementAt(index - 2)
                                                .isFollowing
                                            ? "drawables/Add_contact-01.png"
                                            : "drawables/action-01.png",
                                        height: !userList
                                                .elementAt(index - 2)
                                                .isFollowing
                                            ? 36
                                            : 28,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: index - 2 != userList.length,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Divider(
                                        color: Constants.COLOR_PRIMARY_GREY,
                                        thickness: 2.5,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Visibility(
              visible: isSearchBtnClicked ? true : false,
              child: Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isSearchBtnClicked = false;
                                searchController.text = "";
                                serachUsers = List();
                              });
                            },
                            child: AlMajlisTextViewBold(
                              "CANCEL",
                              size: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: 32.0,
                          margin: EdgeInsets.only(left: 10.0),
                          padding: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Constants.COLOR_DARK_GREY),
                          child: TextField(
                            controller: searchController,
                            onChanged: _onChangeHandler,
                            style: TextStyle(
                              fontFamily: 'ProximaNovaSemiBold',
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Constants.COLOR_DARK_GREY,
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white30,
                                      size: 20,
                                    ),
                                  )),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: "ProximaNovaSemiBold",
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ))
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: serachUsers.length,
                          itemBuilder: (BuildContext contex, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 10, right: 20),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        null !=
                                                    serachUsers
                                                        .elementAt(index)
                                                        .thumbUrl &&
                                                !serachUsers
                                                    .elementAt(index)
                                                    .thumbUrl
                                                    .isEmpty
                                            ? GestureDetector(
                                                onTap: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivityProfile(
                                                              userId: serachUsers
                                                                  .elementAt(
                                                                      index)
                                                                  .userId,
                                                            )),
                                                  );
                                                },
                                                child:
                                                    AlMajlisProfileImageWithStatus(
                                                        serachUsers
                                                            .elementAt(index)
                                                            .thumbUrl,
                                                        50.0,
                                                        isPro: null !=
                                                                serachUsers
                                                                    .elementAt(
                                                                        index)
                                                                    .isPro
                                                            ? serachUsers
                                                                .elementAt(
                                                                    index)
                                                                .isPro
                                                            : false),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivityProfile(
                                                              userId: serachUsers
                                                                  .elementAt(
                                                                      index)
                                                                  .userId,
                                                            )),
                                                  );
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: serachUsers
                                                              .elementAt(index)
                                                              .isPro
                                                          ? Constants
                                                              .COLOR_PRIMARY_TEAL
                                                          : Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
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
                                              ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ActivityProfile(
                                                                  userId: serachUsers
                                                                      .elementAt(
                                                                          index)
                                                                      .userId,
                                                                )),
                                                      );
                                                    },
                                                    child:
                                                        AlMajlisTextViewWithVerified(
                                                      serachUsers
                                                              .elementAt(index)
                                                              .firstName +
                                                          " " +
                                                          serachUsers
                                                              .elementAt(index)
                                                              .lastName,
                                                      isVerified: false,
                                                      size: 16,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      AlMajlisTextViewMedium(
                                                        serachUsers
                                                            .elementAt(index)
                                                            .occupation,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      AlMajlisTextViewMedium(
                                                        serachUsers
                                                            .elementAt(index)
                                                            .country,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              )),
        ],
      ),
      hasBottomNaviagation: true,
      bottomNavigationScreenType: 1,
      refreshFunction: refreshDiscover,
    );
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

  Expanded showTotalCards(String imageName, String totalNumbers, String name) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Constants.COLOR_DARK_GREY,
              borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imageName,
                  height: 28.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AlMajlisTextViewBold(
                          totalNumbers,
                          size: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          AlMajlisTextViewBold(name),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLocationCordinates() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude.toString();
    lng = position.longitude.toString();
    if (null == lat || null == lng) {
      showDistanceFilters = false;
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
          if (null != response.payload.postCount) {
            totalPosts = response.payload.postCount;
          }
          if (null != response.payload.userCount) {
            totalUsers = response.payload.userCount;
          }
        });
      }
    }
  }

  getNearMeUsers(lat, lng) async {
    core.startLoading(_context);
    ResponseUsers response;
    try {
      response = await core.getNearMeUsers(lat, lng);
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
                    getNearMeUsers(lat, lng);
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
    if (!core.systemCanHandel(response, from: "discover")) {
      if (response.status.statusCode == 0) {
        List<User> tempUserList = List();
        print(response.payload.length);
        for (int index = 0; index < response.payload.length; index++) {
          if (response.payload.elementAt(index).userId !=
              core.getCurrentUser().userId)
            tempUserList.add(response.payload.elementAt(index));
        }
        setState(() {
          nearMeUsers = tempUserList;
          showDistanceFilters = true;
        });
      }
    }
  }

  getProUsers(lat, lng, distance, String country,
      {isPaginationCall = false}) async {
    if (!isPaginationCall) {
      core.startLoading(_context);
    }
    ResponseUsers response;
    try {
      response = await core.getUsersForDiscover(
          lat, lng, distance, country, true, proUsers.length);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      if (!isPaginationCall) {
        core.stopLoading(_context);
      }
    } catch (_) {
      if (!isPaginationCall) {
        core.stopLoading(_context);
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
                    getProUsers(lat, lng, distance, country);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    if (!isPaginationCall) {
      core.stopLoading(_context);
    }
    if (!core.systemCanHandel(response, from: "discover")) {
      if (response.status.statusCode == 0) {
        List<User> tempUserList = List();
        print(response.payload.length);
        for (int index = 0; index < response.payload.length; index++) {
          if (response.payload.elementAt(index).userId !=
              core.getCurrentUser().userId)
            tempUserList.add(response.payload.elementAt(index));
        }
        if (tempUserList.length == 0) {
          fetchMoreProUsers = false;
        }
        setState(() {
          if (isPaginationCall) {
            proUsers.addAll(tempUserList);
          } else {
            proUsers = tempUserList;
          }
        });
      }
    }
  }

  getUserList(
      lat, lng, distance, String country, bool prousers, int offset) async {
    core.startLoading(_context);
    ResponseUsers response;
    try {
      response = await core.getUsersForDiscover(
          lat, lng, distance, country, prousers, offset);
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
                    getUserList(lat, lng, distance, country, prousers, offset);
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
    if (!core.systemCanHandel(response, from: "discover")) {
      if (response.status.statusCode == 0) {
        List<User> tempUserList = List();
        print(response.payload.length);
        for (int index = 0; index < response.payload.length; index++) {
          if (response.payload.elementAt(index).userId !=
              core.getCurrentUser().userId) {
            tempUserList.add(response.payload.elementAt(index));
          }
        }
        if (response.payload.length != tempUserList.length) {
          hasRemovedSelf = true;
        }
        if (tempUserList.length > 0) {
          fetchMore = true;
          setState(() {
            userList.addAll(tempUserList);
            print(userList.length);
          });
        } else {
          fetchMore = false;
        }
      }
    }
  }

  void addConnection(index) async {
    String userId = userList.elementAt(index).userId;
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.addConnection(userId);
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
                    addConnection(userId);
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
//        hasRemovedSelf = false;
//        userList = List();
//        fetchMore = true;
//        getUserList(
//            lat,
//            lng,
//            selectedDistance == 0 ? null : (selectedDistance * 1000).toString(),
//            selectedCountry,
//            toogleValue,0);
        setState(() {
          userList.elementAt(index).isFollowing =
              !userList.elementAt(index).isFollowing;
        });
      }
    }
  }

  void removeConnection(index) async {
    String userId = userList.elementAt(index).userId;
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.removeConnection(userId);
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
                    removeConnection(userId);
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
//        fetchMore = true;
//        hasRemovedSelf = false;
//        userList = List();
//        getUserList(
//            lat,
//            lng,
//            selectedDistance == 0 ? null : (selectedDistance * 1000).toString(),
//            selectedCountry,
//            toogleValue,0);
        setState(() {
          userList.elementAt(index).isFollowing =
              !userList.elementAt(index).isFollowing;
        });
      }
    }
  }

  @override
  onWidgetInitialized() async {
    // TODO: implement onWidgetInitialized
    getUtils();
    getUserList(null, null, null, null, false, 0);
    getProUsers(null, null, null, null);
    await getLocationCordinates();
    getNearMeUsers(lat, lng);
//    getUserList(lat, lng, 2,distance: selectedDistance == 0 ? null : (selectedDistance*1000).toString(), prousers: toogleValue, country: selectedCountry == null ? null : selectedCountry);
  }

  refreshDiscover() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude.toString();
    lng = position.longitude.toString();
    fetchMore = true;
    hasRemovedSelf = false;
    userList = List();
    userList = List();
    getUserList(
        lat,
        lng,
        selectedDistance == 0 ? null : (selectedDistance * 1000).toString(),
        selectedCountry,
        toogleValue,
        0);
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
