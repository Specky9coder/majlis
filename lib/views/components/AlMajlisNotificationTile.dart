import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivitySinglePost.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/core/wrappers/AlMajlisNotification.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class AlMajlisNotificationTile extends StatefulWidget {
  bool isTick;
  bool isMultiFav;
  AlMajlisNotification notification;
  bool hasDivider;
  AlMajlisNotificationTile(this.notification,
      {Key key,
      this.isTick = false,
      this.isMultiFav = false,
      this.hasDivider = true})
      : super(key: key);

  @override
  _AlMajlisNotificationTileState createState() =>
      _AlMajlisNotificationTileState();
}

class _AlMajlisNotificationTileState
    extends ActivityStateBase<AlMajlisNotificationTile> {
  var typeOfStringNotification;

  @override
  Widget build(BuildContext context) {
    String image;
    String name;
    String title;
    String description;
    String icon;
    String userId;
    bool isPro = false;
    String postId;
    var navigate;
    // print('\n\n\n');
    // print(widget.notification);
    // print('\n\n\n');
    bool emptyData = false;

    switch (widget.notification.type) {
      case 1:
        if (widget.notification.likeBy != null) {
          image = widget.notification.likeBy.thumbUrl;
          name = widget.notification.likeBy.firstName +
              " " +
              widget.notification.likeBy.lastName;
          title = "Liked your post:";
          description = widget.notification.post.text;
          icon = "drawables/ic_heart_outline_white_18dp.png";
          userId = widget.notification.likeBy.userId;
          isPro = widget.notification.likeBy.isPro;
          postId = widget.notification.post.postId;
          navigate = ActivitySinglePost(id: postId);
          emptyData = false;
        } else {
          // image = null;
          // name = " ";
          // title = "Liked your post:";
          // description = widget.notification.post.text;
          // icon = "drawables/ic_heart_outline_white_18dp.png";
          // userId = " ";
          // isPro = false;
          // postId = widget.notification.post.postId ?? " ";
          // navigate = ActivitySinglePost(id: postId);
          emptyData = true;
        }

        break;
      case 2:
        if (widget.notification.user != null) {
          image = widget.notification.comment.user.thumbUrl;
          name = widget.notification.comment.user.firstName +
              " " +
              widget.notification.comment.user.lastName;
          title = "Replied to your post:";
          description = widget.notification.comment.comment;
          icon = "drawables/replied.png";
          userId = widget.notification.comment.user.userId;
          isPro = widget.notification.comment.user.isPro;
          postId = widget.notification.comment.post.postId;
          navigate = ActivitySinglePost(id: postId);
          emptyData = false;
        } else {
          emptyData = true;
        }
        break;
      case 8:
        if (widget.notification.likeBy != null) {
          image = widget.notification.likeBy.thumbUrl;
          name = widget.notification.likeBy.firstName +
              " " +
              widget.notification.likeBy.lastName;
          title = "Liked Your Comment";
          description = widget.notification.comment.comment;
          icon = "drawables/ic_heart_outline_white_18dp.png";
          isPro = widget.notification.likeBy.isPro;
          userId = widget.notification.likeBy.userId;
          postId = widget.notification.comment.post.postId;
          navigate = ActivitySinglePost(id: postId);
          emptyData = false;
        } else {
          emptyData = true;
        }

        break;
      case 9:
        if (widget.notification.messageBy != null) {
          image = widget.notification.messageBy.thumbUrl;
          name = widget.notification.messageBy.firstName +
              " " +
              widget.notification.messageBy.lastName;
          title = "Messaged You.";
          description = "";
          icon = "drawables/messages.png";
          isPro = widget.notification.messageBy.isPro;
          userId = widget.notification.messageBy.userId;
          navigate = ActivityUserChat(
            myUserId: core.getCurrentUser().userId,
            otherPersonUserId: widget.notification.messageBy.userId,
          );
          emptyData = false;
        } else {
          emptyData = true;
        }

        break;
      case 10:
        if (widget.notification.forwardedBy != null) {
          image = widget.notification.forwardedBy.thumbUrl;
          name = widget.notification.forwardedBy.firstName +
              " " +
              widget.notification.forwardedBy.lastName;
          title = "Forwarded your profile:";
          description = "";
          icon = "drawables/replied.png";
          isPro = widget.notification.forwardedBy.isPro;
          userId = widget.notification.forwardedBy.userId;
          navigate = ActivityProfile(
            userId: widget.notification.forwardedBy.userId,
          );
          emptyData = false;
        } else {
          emptyData = true;
        }

        break;
      default:
        {
          emptyData = true;
        }
        break;

//      case 3:
//     if (widget.notification.user != null) {
      //  image = notification.comment.user.thumbUrl;
//        name = notification.comment.user.firstName +
//            " " +
//            notification.comment.user.lastName;
//        title = "Replied to your post:";
//        description = notification.comment.comment;
//        icon = "drawables/replied.png";
//        postId = notification.post.postId;
      // emptyData = false;

//         } else {
//           emptyData = true;
//         }
//
//        break;
//      case 4:
      //  if (notification.comment != null) {
      // image = notification.comment.user.thumbUrl;
//        name = notification.comment.user.firstName +
//            " " +
//            notification.comment.user.lastName;
//        title = "Replied to your post:";
//        description = notification.comment.comment;
//        icon = "drawables/replied.png";
      // emptyData = false;

//         } else {
//           emptyData = true;
//         }
//
//        break;

    }
    return emptyData == true
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigate),
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 14.0,
              ),
              color:
                  widget.notification.read != null && !widget.notification.read
                      ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                      : Colors.black, // Colors.black,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        widget.isMultiFav
                            ? Container(
                                margin: EdgeInsets.only(left: 16.0, right: 4.0),
                                height: 60.0,
                                width: 60.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: AlMajlisProfileImageWithStatus(
                                          image, 32.0),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: AlMajlisProfileImageWithStatus(
                                          image, 32.0),
                                    )
                                  ],
                                ),
                              )
                            : null != image && !image.isEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ActivityProfile(
                                                  userId: userId,
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: AlMajlisProfileImageWithStatus(
                                        image,
                                        60.0,
                                        isPro: isPro,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isPro
                                              ? Constants.COLOR_PRIMARY_TEAL
                                              : Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
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
                          child: GestureDetector(
                            onTap: () {
                              if (null != navigate) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => navigate),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityProfile(
                                                        userId: userId,
                                                      )),
                                            );
                                          },
                                          child: AlMajlisTextViewBold(
                                            name,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: timeago
                                                    .format(
                                                        widget.notification
                                                            .createdAt,
                                                        locale: 'en_short')
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "ProximaNovaBold",
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          icon,
                                          color: Colors.white,
                                          height: 20,
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AlMajlisTextViewBold(
                                                  title,
                                                  size: 14,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child:
                                                          AlMajlisTextViewMedium(
                                                        description,
                                                        maxLines: 1,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.hasDivider,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 2.5,
                          width: MediaQuery.of(context).size.width,
                          color: Constants.COLOR_PRIMARY_GREY,
                        )),
                  )
                ],
              ),
            ),
          );
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}
