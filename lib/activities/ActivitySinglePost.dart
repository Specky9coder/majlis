import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityEditComment.dart';
import 'package:almajlis/activities/ActivityPhotoZoom.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityReplyToPost.dart';
import 'package:almajlis/activities/MyCustomClipper.dart';
import 'package:almajlis/core/server/wrappers/ResponseComments.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePost.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/BottomSheetOperations.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';
import 'package:almajlis/views/bottomsheets/ReportPostBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisShortPostCard.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/dialogs/DialogReport.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ActivitySinglePost extends StatefulWidget {
  String id;
  ActivitySinglePost({Key key, this.id}) : super(key: key);

  @override
  _ActivitySinglePostState createState() => _ActivitySinglePostState();
}

class _ActivitySinglePostState extends ActivityStateBase<ActivitySinglePost> {
  bool isCameraClicked = false;
  bool isIncreasedFavCount = false;
  int counter = 0;
  bool isListItemSelected = false;
  bool isUserLoggedIn = true;
  BuildContext _context;
  AlMajlisPost post = AlMajlisPost();
  List<AlMajlisComment> comments = List();
  String name = "";
  String thumbUrl = "";
  String captionText = "";
  var loaction = "";
  DateTime date;
  int views = 0;
  int commentsCount = 0;
  int likes = 0;
  String image = "";
  bool isUserPro = false;
  bool isPro = false;
  String imageUrl = "";
  final scaffoldState = GlobalKey<ScaffoldState>();
  String location;
  final picker = ImagePicker();
  bool fetchMore =  true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    isUserLoggedIn = core.isUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    if (null != post && null == post.isLiked) post.isLiked = false;
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 20.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: comments.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Constants.COLOR_DARK_GREY,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0))),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          null != thumbUrl && !thumbUrl.isEmpty
                                              ? GestureDetector(
                                                  child:
                                                      AlMajlisProfileImageWithStatus(
                                                    thumbUrl,
                                                    50.0,
                                                    isPro: isPro,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActivityProfile(
                                                                userId: post
                                                                    .postUser
                                                                    .userId,
                                                              )),
                                                    );
                                                  },
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActivityProfile(
                                                                userId: post
                                                                    .postUser
                                                                    .userId,
                                                              )),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isPro
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            AlMajlisTextViewBold(
                                                          name,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      // ),
//                                                      Icon(
//                                                        Icons.done,
//                                                        color: Colors.teal,
//                                                        size: 14,
//                                                      ),
                                                      AlMajlisTextViewRegular(
                                                        null != date
                                                            ? timeago
                                                                .format(date,
                                                                    locale:
                                                                        'en_short')
                                                                .toUpperCase()
                                                            : "",
                                                        size: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      AlMajlisTextViewMedium(
                                                        null != post.location
                                                            ? location
                                                            : "",
                                                        size: 12,
                                                        color: Colors.grey,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 4.0),
                                                        child: Image.asset(
                                                          "drawables/views.png",
                                                          color: Colors.grey,
                                                          height: 12,
                                                        ),
                                                      ),
                                                      AlMajlisTextViewMedium(
                                                        views.toString(),
                                                        size: 12,
                                                        color: Colors.grey,
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
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 65.0,
                                                  right: 14.0,
                                                  top: 8.0),
                                              child: Linkify(
                                                onOpen: (link) async {
                                                  if (await canLaunch(link.url)) {
                                                    await launch(link.url);
                                                  } else {
                                                    throw 'Could not launch $link';
                                                  }
                                                },
                                                text: captionText,
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
                                          )
                                        ],
                                      ),
                                      null != image && !image.isEmpty
                                          ?
                                          //    Row(
                                          //     children: <Widget>[
                                          //       // SizedBox(
                                          //       //   width: 50.0,
                                          //       // ),
                                          //       Expanded(
                                          //         child: GestureDetector(
                                          //           onTap: () {
                                          //             Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                   builder: (context) =>
                                          //                       ActivityPhotoZoom(
                                          //                           image)),
                                          //             );
                                          //           },
                                          //           child: Container(
                                          //             margin: EdgeInsets.only(
                                          //                 left: 15.0,
                                          //                 right: 14.0,
                                          //                 top: 8.0),
                                          //             padding: EdgeInsets.only(
                                          //                 top: 2.0,
                                          //                 bottom: 2.0,
                                          //                 left: 2.0,
                                          //                 right: 2.0),
                                          //             height: 110.0,
                                          //             width: 150.0,
                                          //             decoration: BoxDecoration(
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(
                                          //                             8.0),
                                          //                 border: Border.all(
                                          //                     color: Colors
                                          //                         .white)),
                                          //             child: CachedNetworkImage(
                                          //               imageUrl: image,
                                          //               errorWidget: (context,
                                          //                   url, error) {
                                          //                 return Container();
                                          //               },
                                          //               placeholder: (context,
                                          //                       url) =>
                                          //                   Container(
                                          //                       child: Center(
                                          //                           child:
                                          //                               CircularProgressIndicator())),
                                          //               fit: BoxFit.scaleDown,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   )
                                          Row(
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
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white)),
                                                      child: CachedNetworkImage(
                                                        imageUrl: image,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Container();
                                                        },
                                                        placeholder: (context,
                                                                url) =>
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
                                            )
                                          : Container(),
                                      Visibility(
                                        visible: isUserLoggedIn,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 65.0,
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: widegtIconWithCounterText(
                                                    "drawables/comment-01.png",
                                                    commentsCount.toString()),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 32.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    post.isLiked
                                                        ? decrement()
                                                        : increment();
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                              child: Icon(
                                                                post.isLiked
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                color: post
                                                                        .isLiked
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .grey,
                                                                size: 16,
                                                              )),
                                                        ),
                                                        TextSpan(
                                                            text: post.likeCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: post
                                                                        .isLiked
                                                                    ? Constants
                                                                        .COLOR_PRIMARY_TEAL
                                                                    : Colors
                                                                        .grey)),
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
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  ClipPath(
                                    child: Container(
                                      width: 30,
                                      height: 20,
                                      color: Constants.COLOR_DARK_GREY,
                                    ),
                                    clipper: MyCustomClipper(),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                        if(index == comments.length -2) {
                          if(fetchMore) {
                            Future.delayed(Duration(seconds: 1), () {
                              getComments(comments.length);
                            });
                          }
                        }
                        return SinglePostCommentCard(
                          comments.elementAt(index - 1),
                          incrementComment: incrementComment,
                          decrementComment: decrementComment,
                          isLiked: comments.elementAt(index - 1).isLiked,
                          likeCount: comments.elementAt(index - 1).likeCount,
                          index: index - 1,
                          image: comments.elementAt(index - 1).thumb,
                          moreClick: () {
                            moreCLick(index - 1);
                          },
                        );
                      }),
                )),
                Visibility(
                  visible: isUserLoggedIn,
                  child: Row(
                    children: <Widget>[
                      null != imageUrl && !imageUrl.isEmpty
                          ? AlMajlisProfileImageWithStatus(
                              imageUrl,
                              50.0,
                              isPro: isUserPro,
                            )
                          : Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isUserPro
                                      ? Constants.COLOR_PRIMARY_TEAL
                                      : Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: [
                                        Colors.purple,
                                        Colors.teal
                                      ])),
                                ),
                              ),
                            ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityReplyToPost(
                                        post: post,
                                      )),
                            );
                            comments = List();
                            getComments(0);
                            getPost();
                          },
                          child: Container(
                            height: 45.0,
                            margin: EdgeInsets.only(left: 10.0),
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Constants.COLOR_DARK_GREY),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Reply to this post ",
                                    style: TextStyle(
                                        fontFamily: 'ProximaNovaMedium',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.grey),
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
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
            "Post",
            size: 16,
          ),
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivityReplyToPost(post: post,image: pickedFile)),
      );
      comments = List();
      getComments(0);
    }
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivityReplyToPost(post: post,image: pickedFile)),
      );
      comments = List();
      getComments(0);
    }
  }

  deleteCommentThroughDialog(int index) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: AlMajlisTextViewBold(
                    "Do you want to delete Comment ?",
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
                  deleteComment(index);
                },
                child: new Text(
                  "YES",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: Constants.COLOR_PRIMARY_TEAL,
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "NO",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: Constants.COLOR_PRIMARY_TEAL,
              ),
            ],
          );
        });
  }

  void moreCLick(index) {
    if (comments.elementAt(index).user.userId == core.getCurrentUser().userId) {
      scaffoldState.currentState.showBottomSheet((context) =>
          BottomSheetOperations(editComment, deleteCommentThroughDialog, index));
    } else if (post.postUser.userId == core.getCurrentUser().userId) {
      scaffoldState.currentState
          .showBottomSheet((context) => ReportPostBottomSheet(
                reportClicked: () {
                  deleteCommentThroughDialog(index);
                },
                isDelete: true,
              ));
    } else {
      scaffoldState.currentState
          .showBottomSheet((context) => ReportPostBottomSheet(
                reportClicked: () {
                  reportClicked(index);
                },
              ));
    }
  }

  editComment(index) async {
    Navigator.pop(_context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ActivityEditComment(
                post: post,
                comment: comments.elementAt(index),
              )),
    );
    comments = List();
    getComments(0);
  }

  deleteComment(index) async {
    Navigator.pop(_context);
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.deleteComment(comments.elementAt(index).postId);
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
                    deleteComment(comments.elementAt(index).postId);
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
        comments = List();
        getComments(0);
      }
    }
  }

  void reportClicked(index) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return DialogReport(0);
        }).then((value) {
      reportComment(index, Constants.reportReasons.elementAt(value));
    });
  }

  void reportComment(index, String reason) async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response =
          await core.reportComment(comments.elementAt(index).postId, reason);
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
                    reportComment(comments.elementAt(index).postId, reason);
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
            msg: "Comment Has been reported",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
      }
    }
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

  void decrementComment(index) async {
    setState(() {
      comments.elementAt(index).isLiked = false;
      if (null != comments.elementAt(index).likeCount)
        comments.elementAt(index).likeCount--;
    });
    AlMajlisComment comment = comments.elementAt(index);
    ResponseOk response;
    try {
      response = await core.dislikeComment(comment.postId);
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
                    decrementComment(index);
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
        comments.elementAt(index).isLiked = true;
        if (null != comments.elementAt(index).likeCount > 1)
          comments.elementAt(index).likeCount++;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          comments.elementAt(index).isLiked = true;
          if (null != comments.elementAt(index).likeCount)
            comments.elementAt(index).likeCount++;
        });
      }
    }
  }

  void incrementComment(index) async {
    setState(() {
      comments.elementAt(index).isLiked = true;
      if (null != comments.elementAt(index).likeCount)
        comments.elementAt(index).likeCount++;
    });
    AlMajlisComment comment = comments.elementAt(index);
    ResponseOk response;
    try {
      response = await core.likeComment(comment.postId);
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
                    incrementComment(index);
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
        comments.elementAt(index).isLiked = false;
        if (null != comments.elementAt(index).likeCount > 1)
          comments.elementAt(index).likeCount--;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          comments.elementAt(index).isLiked = false;
          if (null != comments.elementAt(index).likeCount)
            comments.elementAt(index).likeCount--;
        });
      }
    }
  }

  void decrement() async {
    setState(() {
      post.isLiked = false;
      if (null != post.likeCount) post.likeCount--;
    });
    ResponseOk response;
    try {
      response = await core.dislikePost(post.postId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    } catch (e) {
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    decrement();
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
        post.isLiked = true;
        if (null != post.likeCount > 1) post.likeCount++;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          post.isLiked = true;
          if (null != post.likeCount) post.likeCount++;
        });
      }
    }
  }

  void increment() async {
    setState(() {
      post.isLiked = true;
      if (null != post.likeCount)
        post.likeCount++;
      else
        post.likeCount = 1;
    });
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
                    increment();
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
        post.isLiked = false;
        if (post.likeCount > 1)
          post.likeCount--;
        else
          post.likeCount = 0;
      });
    } else {
      if (response.status.statusCode != 0) {
        setState(() {
          post.isLiked = false;
          if (post.likeCount > 1)
            post.likeCount--;
          else
            post.likeCount = 0;
        });
      }
    }
  }

  void getPost() async {
    core.startLoading(_context);
    ResponsePost response;
    try {
      response = await core.getPostDetails(widget.id);
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
                    getPost();
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
    if (!core.systemCanHandel(response, from: "post")) {
      if (response.status.statusCode == 0) {
        setState(() {
          post = response.payload;
          if (null != post.postUser.thumbUrl &&
              !post.postUser.thumbUrl.isEmpty) {
            thumbUrl = post.postUser.thumbUrl;
          }
          if (null != post.postUser.firstName &&
              !post.postUser.firstName.isEmpty &&
              null != post.postUser.lastName &&
              !post.postUser.lastName.isEmpty) {
            name = post.postUser.firstName + " " + post.postUser.lastName;
          }
          if (null != post.text && !post.text.isEmpty) {
            captionText = post.text;
          }
          if (null != post.createdAt) {
            print(post.createdAt);
            date = post.createdAt;
          }
          if (null != post.commentCount) {
            commentsCount = post.commentCount;
          }
          if (null != post.likeCount) {
            likes = post.likeCount;
          }
          if (null != post.viewCount) {
            views = post.viewCount;
          }
          if (null != post.location) {
            if (null != post.location.city && !post.location.city.isEmpty) {
              location = post.location.city;
            }

            if (null != post.location.country &&
                !post.location.country.isEmpty) {
              if (location.length > 0) {
                location = location + ", " + post.location.country;
              } else
                location = location + post.location.country;
            }
          }
          if (null != post.file && !post.file.isEmpty) {
            image = post.file;
          }
          if (null != post.postUser.isPro) {
            isPro = post.postUser.isPro;
          }
        });
        comments = List();
        getComments(0);
      }
    }
  }

  void getComments(offset) async {
    core.startLoading(_context);
    ResponseComments response;
    try {
      response = await core.getComments(widget.id, offset);
      print(response);
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
                    getComments(offset);
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
    if (!core.systemCanHandel(response, from: "comments")) {
      if (response.status.statusCode == 0) {
        if(response.payload.length == 0) {
          fetchMore = false;
        }
        setState(() {
          comments.addAll(response.payload);
        });
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

    if (!core.systemCanHandel(response, from: "user")) {
      if (response.status.statusCode == 0) {
        setState(() {
          if (null != response.payload.thumbUrl &&
              !response.payload.thumbUrl.isEmpty) {
            imageUrl = response.payload.thumbUrl;
          }
          isUserPro = response.payload.isPro;
        });
      }
    }
    core.stopLoading(_context);
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getPost();
    getUser();
  }
}

class SinglePostCommentCard extends StatelessWidget {
  AlMajlisComment comment;
  var incrementComment;
  var decrementComment;
  int likeCount;
  bool isLiked;
  int index;
  var moreClick;
  var image;
  SinglePostCommentCard(this.comment,
      {Key key,
      this.incrementComment,
      this.decrementComment,
      this.likeCount = 0,
      this.isLiked = false,
      this.index,
      this.image,
      this.moreClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(comment);
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8),
      child: AlMajlisShortPostCard(
        comment.user.thumbUrl,
        comment.user.firstName + " " + comment.user.lastName,
        timeago.format(comment.createdAt, locale: 'en_short').toUpperCase(),
        comment.comment,
        isSinglePost: true,
        id: comment.user.userId,
        incrementComment: incrementComment,
        decrementComment: decrementComment,
        likeCount: likeCount,
        isLiked: isLiked,
        index: index,
        isPro: comment.user.isPro,
        moreClick: moreClick,
        commentImage: image,
      ),
    );
  }
}
