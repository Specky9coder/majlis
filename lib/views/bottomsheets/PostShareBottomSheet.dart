import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlMajlisRadioButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostShareBottomSheet extends StatefulWidget {

  var copyLink;
  var shareLink;
  var sahreToUsers;
  int index;
  bool showCopyAndShare;

  PostShareBottomSheet({
    this.copyLink,
    this.shareLink,
    this.sahreToUsers,
    this.index,
    this.showCopyAndShare = true
  });

  @override
  _PostShareBottomSheetState createState() => _PostShareBottomSheetState();
}

class _PostShareBottomSheetState extends ActivityStateBase<PostShareBottomSheet> {
  TextEditingController searchController = TextEditingController();
  List<SearchModel> selectedUsers = List();
  List<SearchModel> searchUsers = List();
  List<SearchModel> showUsers = List();
  BuildContext _buildContext;
  Timer searchOnStoppedTyping;

  _onChangeHandler(String value ) {
    const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () {
      if(value.length > 2) {
        searchUser(value);
      }
      else {
        setState(() {
          searchUsers = List();
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Container(
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 470,
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
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
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
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Constants.COLOR_PRIMARY_TEAL_SHADOW),
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
                              padding: const EdgeInsets.only(
                                  bottom: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0),
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
                    ),
                    Expanded(
                      child: Container(
                        height: 200.0,
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        // child: Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: selectedUsers.length + searchUsers.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              if(index < selectedUsers.length) {
                                return shareUserRow(index, true);
                              }
                              return shareUserRow(index - selectedUsers.length, false);
                            }),
                      ),
                    ),
                    //  ),
                    Divider(
                      height: 2,
                      color: Colors.white,
                    ),
                    Visibility(
                      visible: widget.showCopyAndShare,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              widget.copyLink(widget.index);
                            },
                            child: shareLinkWidgetRow(
                                context, Icons.link, "Copy link to post"),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.shareLink(widget.index);
                            },
                            child: shareLinkWidgetRow(
                                context, Icons.file_upload, "Share post via..."),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300.0,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 12.0),
                        padding: EdgeInsets.only(
                            left: 2.0, right: 2.0, top: 3.0, bottom: 3.0),
                        decoration: BoxDecoration(
                          color: Constants.COLOR_DARK_TEAL,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.COLOR_PRIMARY_TEAL,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  1.0, 1.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: FlatButton(
                          color: Constants.COLOR_DARK_TEAL,
                          onPressed: () {
                            widget.sahreToUsers(selectedUsers, widget.index);
                          },
                          child: Text(
                            "SEND",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget shareUserRow(index, bool isSelected) {
    SearchModel user;

    if(isSelected) {
      user = selectedUsers.elementAt(index);
    }
    else
      user = searchUsers.elementAt(index);

    return Container(
      padding: EdgeInsets.symmetric(horizontal:8, vertical: 8.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              null != user.user.thumbUrl &&
                  !user.user.thumbUrl.isEmpty
                  ? GestureDetector(
                onTap: () {
                  isSelected ? deSelectUser(index) : selectUser(index);
                },
                child: AlMajlisProfileImageWithStatus(
                    user.user.thumbUrl, 50.0,
                    isPro: user.user.isPro),
              )
                  : GestureDetector(
                onTap: () {
                  isSelected ? deSelectUser(index) : selectUser(index);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.user.isPro
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: AlMajlisTextViewBold(
                                user.user.firstName + " " + user.user.lastName,
                                size: 16,
                              ),
                              onTap: () {
                                isSelected ? deSelectUser(index) : selectUser(index);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          AlMajlisTextViewMedium(
                            user.user.occupation,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          AlMajlisTextViewMedium(
                            user.user.country,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  isSelected ? deSelectUser(index) : selectUser(index);
                },
                child: Container(
                    height: 15.0,
                    width: 15.0,
                    child: user.isSelected
                        ? AlMajlisImageIcons(
                      "drawables/tick-01.png",
                      iconHeight: 10.0,
                    )
                        : new CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: CircleAvatar(
                            minRadius: 10.0, backgroundColor: Colors.black),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void searchUser(String searchString) async {
    core.startLoading(_buildContext);
    ResponseUsers response;
    try {
      response = await core.searchUsers(searchString,0);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_buildContext);
    } catch (_) {
      core.stopLoading(_buildContext);
      showDialog(
          context: _buildContext,
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

    core.stopLoading(_buildContext);
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        FocusScope.of(context).requestFocus(FocusNode());
        List<SearchModel> tempUsers = List();
        for(int index = 0; index< response.payload.length; index++) {
          if(selectedUsers.length > 0) {
            for(int j = 0; j < selectedUsers.length; j++) {
              if(selectedUsers.elementAt(j).user.userId != response.payload.elementAt(index).userId) {
                SearchModel searchModel = SearchModel(false, response.payload.elementAt(index));
                tempUsers.add(searchModel);
                break;
              }
            }
          }
          else {
            if(response.payload.elementAt(index).userId != core.getCurrentUser().userId) {
              SearchModel searchModel = SearchModel(false, response.payload.elementAt(index));
              tempUsers.add(searchModel);
              break;
            }

          }
        }
        setState(() {
          searchUsers = tempUsers;
        });
      }
    }
  }

  selectUser(index) {
    setState(() {
      searchUsers.elementAt(index).isSelected = true;
      selectedUsers.add(searchUsers.elementAt(index));
      searchUsers.removeAt(index);
    });
  }

  deSelectUser(index) {
    if(searchController.text.length > 2) {
      searchUser(searchController.text);
    }
    setState(() {
      selectedUsers.removeAt(index);
    });
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
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

class SearchModel {
  bool isSelected;
  User user;

  SearchModel(this.isSelected, this.user);
}


