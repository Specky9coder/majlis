import 'dart:async';
import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';

import 'package:almajlis/activities/ActivityPhotoZoom.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityReplyToPost.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/MyCustomClipper.dart';
import 'package:almajlis/core/server/wrappers/ResponseSearchPost.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';

import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';

import 'package:almajlis/views/widgets/AlMajlisTextViewWithVerified.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ActivitySearch extends StatefulWidget {
  bool isFromActivityPost;

  ActivitySearch({Key key, this.isFromActivityPost = false}) : super(key: key);

  @override
  _ActivitySearchState createState() => _ActivitySearchState();
}

class _ActivitySearchState extends ActivityStateBase<ActivitySearch> {
  TextEditingController searchController = TextEditingController();
  List<User> serachUsers = List();
  List<AlMajlisPost> serachPosts = List();
  Timer searchOnStoppedTyping;
  BuildContext _context;
  bool fetchMore = true;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                          searchController.text = "";
                          serachUsers = List();
                          Navigator.pop(context);
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
                    padding: EdgeInsets.only(top: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Constants.COLOR_DARK_GREY),
                    child: TextField(
                      controller: searchController,
                      onChanged: _onChangeHandler,
                      style: TextStyle(
                          fontFamily: 'ProximaNovaSemiBold',
                          color: Colors.white,
                          fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: -10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Constants.COLOR_DARK_GREY,
                        prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white30,
                              size: 20,
                            )),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: "ProximaNovaSemiBold",
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ))
                ],
              ),
              widget.isFromActivityPost
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: serachPosts.length,
                          itemBuilder: (BuildContext contex, int index) {
                            if (index == serachUsers.length - 2) {
                              if (fetchMore) {
                                Future.delayed(Duration(seconds: 1), () {
                                  searchPost(searchController.text,
                                      offset: serachUsers.length);
                                });
                              }
                            }
                            return PostListItem(context, index);
                          }),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: serachUsers.length,
                          itemBuilder: (BuildContext contex, int index) {
                            print("COUNTRY");
                            print(serachUsers.elementAt(index).country);
                            print("FIRST NAME");
                            print(serachUsers.elementAt(index).firstName);
                            print("LAST NAME");
                            print(serachUsers.elementAt(index).lastName);
                            print("OCCUPATION");
                            print(serachUsers.elementAt(index).occupation);
                            String name = "";
                            String country = "";
                            String occupation = "";
                            if (null != serachUsers.elementAt(index).country) {
                              country = serachUsers.elementAt(index).country;
                            }
                            if (null !=
                                serachUsers.elementAt(index).occupation) {
                              occupation =
                                  serachUsers.elementAt(index).occupation;
                            }
                            if (null !=
                                serachUsers.elementAt(index).firstName) {
                              name =
                                  serachUsers.elementAt(index).firstName + " ";
                            }
                            if (null != serachUsers.elementAt(index).lastName) {
                              name += serachUsers.elementAt(index).lastName;
                            }

                            if (index == serachUsers.length - 2) {
                              if (fetchMore) {
                                Future.delayed(Duration(seconds: 1), () {
                                  searchUser(searchController.text,
                                      offset: serachUsers.length);
                                });
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 28.0, left: 10, right: 20),
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
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              AlMajlisTextViewWithVerified(
                                                            name,
                                                            isVerified: false,
                                                            size: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            AlMajlisTextViewMedium(
                                                          occupation,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            AlMajlisTextViewMedium(
                                                          country,
                                                          color: Colors.grey,
                                                        ),
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

  InkWell PostListItem(BuildContext context, int index) {
    AlMajlisPost post = serachPosts.elementAt(index);
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
    String name = "";
    if (null != post.postUser.firstName) {
      name = post.postUser.firstName + " ";
    }
    if (null != post.postUser.lastName) {
      name += post.postUser.lastName;
    }
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivitySinglePost(id: post.postId)));
      },
      child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityProfile(
                                                        userId: post
                                                            .postUser.userId,
                                                      )),
                                            );
                                          },
                                          child: AlMajlisProfileImageWithStatus(
                                              post.postUser.thumbUrl, 50.0,
                                              isPro: null != post.postUser.isPro
                                                  ? post.postUser.isPro
                                                  : false),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityProfile(
                                                        userId: post
                                                            .postUser.userId,
                                                      )),
                                            );
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
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ActivityProfile(
                                                                          userId: post
                                                                              .postUser
                                                                              .userId,
                                                                        )),
                                                          );
                                                        },
                                                        child:
                                                            AlMajlisTextViewBold(
                                                          name,
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
                                      ),
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
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityReplyToPost(
                                                      post: post,
                                                    )),
                                          );
                                          // getPosts(DateTime.now());
                                        },
                                        child: widegtIconWithCounterText(
                                            "drawables/comment-01.png",
                                            null != post.commentCount
                                                ? post.commentCount.toString()
                                                : "0"),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          // if (isUserLoggedIn) {
                                          //   post.isLiked
                                          //       ? decrement(index)
                                          //       : increment(index);
                                          // } else {
                                          //   await Navigator.of(context).push(
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               ActivityLogin()));
                                          //   setState(() {
                                          //     isUserLoggedIn =
                                          //         core.isUserLoggedIn();
                                          //     getPosts(DateTime.now());
                                          //   });
                                          // }
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            // if (isUserLoggedIn) {
                                            //   if (post.postUser.userId ==
                                            //       core
                                            //           .getCurrentUser()
                                            //           .userId) {
                                            //     scaffoldState.currentState
                                            //         .showBottomSheet((context) =>
                                            //             BottomSheetOperations(
                                            //                 editPost,
                                            //                 deletePostThroughDialog,
                                            //                 index));
                                            //   } else {
                                            //     scaffoldState.currentState
                                            //         .showBottomSheet((context) =>
                                            //             ReportPostBottomSheet(
                                            //               reportClicked: () {
                                            //                 reportClicked(
                                            //                     index);
                                            //               },
                                            //             ));
                                            //   }
                                            // } else {
                                            //   await Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               ActivityLogin()));
                                            //   setState(() {
                                            //     isUserLoggedIn =
                                            //         core.isUserLoggedIn();
                                            //     getPosts(DateTime.now());
                                            //   });
                                            // }
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
          )),
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
          if (value.length > 2) {
            fetchMore = true;
            serachUsers = List();
            widget.isFromActivityPost ? searchPost(value) : searchUser(value);
          }
        }));
  }

  void searchPost(String searchString, {int offset = 0}) async {
    core.startLoading(_context);
    ResponseSearchPost response;
    try {
      response = await core.searchPosts(searchString, offset);
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
        FocusScope.of(context).requestFocus(FocusNode());
        List<AlMajlisPost> tempPost = List();
        for (int index = 0; index < response.payload.length; index++) {
          // if (response.payload.elementAt(index).userId !=
          //     core.getCurrentUser().userId) {
          tempPost.add(response.payload.elementAt(index));
          // }
        }
        if (response.payload.length == 0) {
          fetchMore = false;
        }
        setState(() {
          serachPosts.addAll(tempPost);
          //posts = response.payload;
        });
      }
    }
  }

  void searchUser(String searchString, {int offset = 0}) async {
    core.startLoading(_context);
    ResponseUsers response;
    try {
      response = await core.searchUsers(searchString, offset);
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
        FocusScope.of(context).requestFocus(FocusNode());
        if (response.payload.length == 0) {
          fetchMore = false;
        }
        setState(() {
          serachUsers.addAll(response.payload);
          //posts = response.payload;
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}
