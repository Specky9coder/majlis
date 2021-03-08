import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';

import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlMajlisShortPostCard.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:path_provider/path_provider.dart' as path_provider;

class ActivityReplyToPost extends StatefulWidget {
  AlMajlisPost post;
  var image;

  ActivityReplyToPost({Key key, this.post, this.image}) : super(key: key);

  @override
  _ActivityReplyToPostState createState() => _ActivityReplyToPostState();
}

class _ActivityReplyToPostState extends ActivityStateBase<ActivityReplyToPost> {
  TextEditingController replyController = TextEditingController();
  var image;
  File _pickedImage;
  final picker = ImagePicker();
  bool isAddImageClicked = false;
  BuildContext _context;
  User user;
  String imageUrl = "";
  bool isPro = false;
  String userId;
  String name = "";
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (null != widget.image) {
        image = File(widget.image.path);
        _pickedImage = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
        child: Scaffold(
      key: scaffoldState,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: AlMajlisTextViewBold(
                      "CANCEL",
                      size: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (null != image) {
                        getSignedUrls();
                      } else {
                        addComment(null);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          color: Constants.COLOR_DARK_TEAL,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: InkWell(
                        child: Center(
                            child: AlMajlisTextViewBold(
                          "REPLY",
                          size: 16,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: AlMajlisShortPostCard(
                        widget.post.postUser.thumbUrl,
                        null != widget.post.postUser.firstName
                            ? widget.post.postUser.firstName +
                                " " +
                                widget.post.postUser.lastName
                            : "" + " " + null != widget.post.postUser.lastName
                                ? widget.post.postUser.lastName
                                : "",
                        timeago
                            .format(widget.post.createdAt, locale: 'en_short')
                            .toUpperCase(),
                        widget.post.text,
                        isSinglePost: false,
                        id: widget.post.postUser.userId,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          null != imageUrl && !imageUrl.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ActivityProfile(
                                                userId: userId,
                                              )),
                                    );
                                  },
                                  child: AlMajlisProfileImageWithStatus(
                                    imageUrl,
                                    50.0,
                                    isPro: isPro,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ActivityProfile(
                                                userId: userId,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isPro
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
                                ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      AlMajlisTextViewRegular(
                                        "Replying to ",
                                        size: 16,
                                      ),
                                      Expanded(
                                        child: AlMajlisTextViewSemiBold(
                                          widget.post.postUser.firstName +
                                              " " +
                                              widget.post.postUser.lastName,
                                          color: Constants.COLOR_DARK_TEAL,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 8.0, right: 8.0),
                                    child: TextField(
                                      controller: replyController,
                                      autofocus: true,
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 4,
                                      decoration: new InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: " Reply to post... "),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              Visibility(
                visible: _pickedImage != null ? true : false,
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: 12.0, right: 10.0, top: 8.0),
                          padding: EdgeInsets.only(
                              top: 2.0, bottom: 2.0, left: 2.0, right: 2.0),
                          height: 100.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.white)),
                          child: _pickedImage != null
                              ? Image.file(
                                  _pickedImage,
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ),
                        Positioned(
                            right: 6.0,
                            top: 4.0,
                            child: GestureDetector(
                                onTap: () {
                                  print("clicked");
                                  setState(() {
                                    _pickedImage = null;
                                    isAddImageClicked = false;
                                  });
                                },
                                child: AlMajlisImageIcons(
                                  "drawables/delete-01.png",
                                  iconHeight: 16,
                                )))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        scaffoldState.currentState.showBottomSheet((context) =>
                            PostMenuBottomSheet(
                                getImageFromCamera, getImageFromGallary));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                        height: 50.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: isAddImageClicked
                                ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                                : Constants.COLOR_DARK_GREY,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              isAddImageClicked
                                  ? "drawables/add_image_blue.png"
                                  : "drawables/add_image-01.png",
                              height: 20,
                            ),
                            AlMajlisTextViewBold(
                              "Add image ",
                              size: 14.0,
                              color: isAddImageClicked
                                  ? Constants.COLOR_DARK_TEAL
                                  : Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   if (pickedFile.path != null) {
  //     image = File(pickedFile.path);
  //     final dir = await path_provider.getTemporaryDirectory();
  //     final targetPath = dir.absolute.path + "/temp.jpg";
  //     image = await testCompressAndGetFile(image, targetPath);
  //     isAddImageClicked = true;
  //   } else {
  //     isAddImageClicked = false;
  //   }
  //   setState(() {
  //     _pickedImage = image;
  //   });
  // }
  Future getImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile.path != null) {
      image = null;
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      _pickedImage = image;
    });
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      image = null;
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      _pickedImage = image;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  }

  void getSignedUrls() async {
    core.startLoading(_context);
    if (null != image) {
      ResponseSignedUrl response;
      try {
        print("extension" + path.extension(path.basename(image.path)));
        response = await core.getSignedUrl(
            path.extension(path.basename(image.path)).substring(1));
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
                      getSignedUrls();
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
          print(response.payload);
          uploadImage(response.payload);
        }
      }
      core.stopLoading(_context);
    } else {
      core.stopLoading(_context);
    }
  }

  void uploadImage(String url) async {
    var response;
    core.startLoading(_context);
    print("Setting token ${core.getToken()}");
    try {
      print("before await");
      response = await http.put(url, body: image.readAsBytesSync());
      core.stopLoading(_context);
      if (response.statusCode == 200) {
        var urlArray = url.split("?");
        print(urlArray.elementAt(0));
        addComment(urlArray.elementAt(0));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      core.stopLoading(_context);
      print('Exception occurs: $e');
    }
  }

  void addComment(String url) async {
    core.startLoading(_context);
    bool hasError = false;
    if (null == replyController.text || replyController.text.isEmpty) {
      hasError = true;
      print("error");
    }

    if (!hasError) {
      AlMajlisComment comment = AlMajlisComment()
        ..comment = replyController.text
        ..thumb = url;

      ResponseOk response;
      try {
        response = await core.addComment(comment, widget.post.postId);
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
                      addComment(url);
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
          Navigator.pop(context);
        }
      }
    } else {
      core.stopLoading(_context);
      Fluttertoast.showToast(
          msg: "Cannot comment without text",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
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

    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        user = response.payload;
        setState(() {
          if (null != user.thumbUrl && !user.thumbUrl.isEmpty) {
            imageUrl = user.thumbUrl;
          }
          if (null != user.firstName &&
              !user.firstName.isEmpty &&
              null != user.lastName &&
              !user.lastName.isEmpty) {
            name = user.firstName + " " + user.lastName;
          }
          isPro = user.isPro;
          userId = user.userId;
        });
      }
    }
    core.stopLoading(_context);
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser();
  }
}
