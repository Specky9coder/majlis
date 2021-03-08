import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityReplyToPost.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/MyCustomClipper.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePosts.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/BottomSheetOperations.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';
import 'package:almajlis/views/bottomsheets/PostShareBottomSheet.dart';
import 'package:almajlis/views/bottomsheets/ReportPostBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/dialogs/DialogReport.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'ActivityEditPost.dart';
import 'ActivityPhotoZoom.dart';

class ActivityViewTotalPost extends StatefulWidget {
  String userId;
  ActivityViewTotalPost(this.userId, {Key key}) : super(key: key);

  @override
  _ActivityViewTotalPostState createState() => _ActivityViewTotalPostState();
}

class _ActivityViewTotalPostState
    extends ActivityStateBase<ActivityViewTotalPost> {
  bool isListItemSelected = false;
  bool isSharePostBtnClicked;
  int counter = 0;
  int totalCount = 57;
  bool isIncreasedFavCount = false;
  bool isMoreSelected = false;
  final _chatsInstance = Firestore.instance.collection("chats");
  final _usersInstance = Firestore.instance.collection("users");
  User user;

  List<AlMajlisPost> posts = List();
  BuildContext _context;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key: scaffoldState,
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: posts.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return PostListItem(context, index);
                    }),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AlMajlisBackButton(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: AlMajlisTextViewBold(
          "Posts (" + posts.length.toString() + ")",
          size: 16,
        ),
      ),
    );
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
    if (null == post.isLiked) post.isLiked = false;
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActivitySinglePost(id: post.postId)),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: 4.0, bottom: index == posts.length - 1 ? 100 : 0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Constants.COLOR_DARK_GREY,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
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
                                                      ActivityProfile()),
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
                                                                        ActivityProfile()),
                                                          );
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
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: AlMajlisTextViewMedium(
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
                                                          const EdgeInsets.only(
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
                                                          color: Colors.red),
                                                    )
                                                  ],
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
                              Row(
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
                              null != post.file && !post.file.isEmpty
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
                                                              post.file)),
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
                                                  imageUrl: post.file,
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
                              Visibility(
                                visible: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                            getPosts();
                                          },
                                          child: widegtIconWithCounterText(
                                              "drawables/comment-01.png",
                                              null != post.commentCount
                                                  ? post.commentCount.toString()
                                                  : "0"),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            post.isLiked
                                                ? decrement(index)
                                                : increment(index);
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
                                                    text: post.likeCount
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: post.isLiked
                                                            ? Constants
                                                                .COLOR_PRIMARY_TEAL
                                                            : Colors.grey)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: post.postUser.userId !=
                                              core.getCurrentUser().userId,
                                          child: GestureDetector(
                                            onTap: () async {
                                              scaffoldState.currentState
                                                  .showBottomSheet((context) =>
                                                      PostShareBottomSheet(
                                                        copyLink: copyLink,
                                                        shareLink: shareLink,
                                                        sahreToUsers:
                                                            shareToUsers,
                                                        index: index,
                                                      ));
                                            },
                                            child: widegtIconWithCounterText(
                                                "drawables/upload-01.png",
                                                null != post.shareCount
                                                    ? post.shareCount.toString()
                                                    : "0"),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (post.postUser.userId ==
                                                  core
                                                      .getCurrentUser()
                                                      .userId) {
                                                scaffoldState.currentState
                                                    .showBottomSheet((context) =>
                                                        BottomSheetOperations(
                                                            editPost,
                                                            deletePost,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                ClipPath(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 20,
                        color: Constants.COLOR_DARK_GREY,
                      ),
                    ],
                  ),
                  clipper: MyCustomClipper(),
                ),
              ],
            )
          ],
        ),
      ),
    );
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

  editPost(index) async {
    Navigator.pop(_context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ActivityEditPost(
                postId: posts.elementAt(index).postId,
              )),
    );
    getPosts();
  }

  deletePost(index) async {
    Navigator.pop(_context);
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
        getPosts();
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

  shareLink(int index) async {
    Navigator.pop(context);
    String idString = 'postId=' + posts.elementAt(index).postId;
    String link = await createLink(idString);
    Share.share('Check out this post on AlMajlis ' + link);
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
                height: 12,
              ),
            ),
          ),
          TextSpan(text: counter, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
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

  void getUser() async {
    core.startLoading(_context);
    ResponseUser response;
    try {
      response = await core.getUser(id: widget.userId);
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
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getPosts();
    getUser();
  }
}
