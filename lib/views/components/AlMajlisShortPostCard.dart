import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityPhotoZoom.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AlmajlisProfileImageWithStatus.dart';

class AlMajlisShortPostCard extends StatefulWidget {
  var image;
  var name;
  var time;
  var caption;
  bool isSinglePost;
  String id;
  var incrementComment;
  var decrementComment;
  int likeCount;
  bool isLiked;
  int index;
  bool isPro;
  var moreClick;
  var commentImage;

  AlMajlisShortPostCard(this.image, this.name, this.time, this.caption,
      {Key key,
      this.isSinglePost = false,
      this.incrementComment,
      this.decrementComment,
      this.likeCount,
      this.isLiked,
      this.index,
      this.isPro = false,
      this.moreClick,
      this.commentImage,
      this.id})
      : super(key: key);

  @override
  _AlMajlisShortPostCardState createState() => _AlMajlisShortPostCardState();
}

class _AlMajlisShortPostCardState
    extends ActivityStateBase<AlMajlisShortPostCard> {
  bool isCommentFavClick = false;
  int counter = 0;
  bool isIncreasedFavCount = false;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserLoggedIn = core.isUserLoggedIn();
    print(isUserLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(10.0) //         <--- border radius here
            ),
        color: Constants.COLOR_DARK_GREY,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                null != widget.image && !widget.image.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          if (null != widget.id) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityProfile(
                                        userId: widget.id,
                                      )),
                            );
                          }
                        },
                        child: AlMajlisProfileImageWithStatus(
                          widget.image,
                          50.0,
                          isPro: widget.isPro,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (null != widget.id) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityProfile(
                                        userId: widget.id,
                                      )),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isPro
                                  ? Constants.COLOR_PRIMARY_TEAL
                                  : Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [Colors.purple, Colors.teal])),
                            ),
                          ),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                child: AlMajlisTextViewBold(
                                  widget.name,
                                  size: 16,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivityProfile(
                                              userId: widget.id,
                                            )),
                                  );
                                },
                              ),
                            ),
                            AlMajlisTextViewBold(
                              widget.time,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Linkify(
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  text: widget.caption,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            widget.isSinglePost
                ? Visibility(
                    visible: isUserLoggedIn,
                    child: Column(
                      children: <Widget>[
                        null != widget.commentImage &&
                                !widget.commentImage.isEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                      widget.commentImage)),
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
                                        height: 100.0,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.commentImage,
                                          errorWidget: (context, url, error) {
                                            return Container();
                                          },
                                          placeholder: (context, url) => Container(
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, right: 8.0, left: 65.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  widget.isLiked
                                      ? widget.decrementComment(widget.index)
                                      : widget.incrementComment(widget.index);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Icon(
                                              widget.isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: widget.isLiked
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 16,
                                            )),
                                      ),
                                      TextSpan(
                                          text: widget.likeCount.toString(),
                                          style: TextStyle(
                                              color: widget.isLiked
                                                  ? Constants.COLOR_PRIMARY_TEAL
                                                  : Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.moreClick,
                                child: AlMajlisImageIcons(
                                  "drawables/More_grey-01.png",
                                  iconHeight: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
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
