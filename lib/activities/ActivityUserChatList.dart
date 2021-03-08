import 'dart:async';
import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityNotification.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/core/server/firebase/database.dart';
import 'package:almajlis/core/server/wrappers/ResponseUsers.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewWithVerified.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityUserChatList extends StatefulWidget {
  ActivityUserChatList({Key key}) : super(key: key);

  @override
  _ActivityUserChatListState createState() => _ActivityUserChatListState();
}

class _ActivityUserChatListState
    extends ActivityStateBase<ActivityUserChatList> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  final _usersInstance = Firestore.instance.collection('users');
  var listOfUsers = List<FirebaseUser>();
  Stream users;
  List<User> serachUsers = List();
  Timer searchOnStoppedTyping;
  TextEditingController searchController = TextEditingController();
  BuildContext _context;
  bool isSearchBtnClicked = false;
  @override
  void initState() {
    getusers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AlMajlisBackButton(
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: AlMajlisTextViewBold(
                              "Chats",
                              size: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearchBtnClicked = true;
                            });
                          },
                          child: AlMajlisRoundIconButton(
                            "drawables/search_bar.png",
                            isSelected: false,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: StreamBuilder(
                          stream: users,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      final listOfUsers =
                                          snapshot.data.documents.toList();
                                      FirebaseUser user = FirebaseUser.fromData(
                                          listOfUsers[index]);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityUserChat(
                                                        myUserId: core
                                                            .getCurrentUser()
                                                            .userId,
                                                        otherPersonUserId:
                                                            user.id,
                                                      )));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  null != user.thumb &&
                                                          !user.thumb.isEmpty
                                                      ? AlMajlisProfileImageWithStatus(
                                                          user.thumb, 70.0,
                                                          isPro: user.isPro)
                                                      : Container(
                                                          height: 70,
                                                          width: 70,
                                                          decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: user.isPro
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
                                                                        Colors
                                                                            .teal
                                                                      ])),
                                                            ),
                                                          ),
                                                        ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            AlMajlisTextViewWithVerified(
                                                              null != user.name &&
                                                                      !user.name
                                                                          .isEmpty
                                                                  ? user.name
                                                                  : "",
                                                              isVerified: false,
                                                              size: 16,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 4.0),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  AlMajlisTextViewBold(
                                                                      null != user.Occupation &&
                                                                              !user
                                                                                  .Occupation.isEmpty
                                                                          ? user
                                                                              .Occupation
                                                                          : ""
                                                                      // booking.bookedBy.occupation
                                                                      ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                AlMajlisTextViewMedium(null !=
                                                                            user
                                                                                .country &&
                                                                        !user
                                                                            .country
                                                                            .isEmpty
                                                                    ? user.country
                                                                    : ""),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              index !=
                                                      snapshot.data.documents
                                                              .length -
                                                          1
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: Divider(
                                                        color: Constants
                                                            .COLOR_PRIMARY_GREY,
                                                        thickness: 2.5,
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Container();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                  visible: isSearchBtnClicked ? true : false,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                        Expanded(
                          child: ListView.builder(
                              itemCount: serachUsers.length,
                              itemBuilder: (BuildContext contex, int index) {

                                String name = "";
                                if(null != serachUsers.elementAt(index).firstName) {
                                  name = serachUsers.elementAt(index).firstName + " ";
                                }
                                if(null != serachUsers.elementAt(index).lastName) {
                                  name = serachUsers.elementAt(index).lastName;
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (context) =>
                                              ActivityUserChat(
                                                myUserId: core
                                                    .getCurrentUser()
                                                    .userId,
                                                otherPersonUserId: serachUsers
                                                    .elementAt(index)
                                                    .userId,
                                              )),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 10, right: 20),
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.transparent,
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
                                                                  ActivityUserChat(
                                                                    myUserId: core
                                                                        .getCurrentUser()
                                                                        .userId,
                                                                    otherPersonUserId:
                                                                        serachUsers
                                                                            .elementAt(
                                                                                index)
                                                                            .userId,
                                                                  )),
                                                        );
                                                      },
                                                      child: AlMajlisProfileImageWithStatus(
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
                                                                  ActivityUserChat(
                                                                    myUserId: core
                                                                        .getCurrentUser()
                                                                        .userId,
                                                                    otherPersonUserId:
                                                                        serachUsers
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
                                                            shape:
                                                                BoxShape.circle,
                                                            color: serachUsers
                                                                    .elementAt(
                                                                        index)
                                                                    .isPro
                                                                ? Constants
                                                                    .COLOR_PRIMARY_TEAL
                                                                : Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
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
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityUserChat(
                                                                            myUserId: core
                                                                                .getCurrentUser()
                                                                                .userId,
                                                                            otherPersonUserId: serachUsers
                                                                                .elementAt(index)
                                                                                .userId,
                                                                          )),
                                                            );
                                                          },
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
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
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
        ),
      ),
    );
  }

  void getusers() async {
    try {
      var user = await _usersInstance
          .where('myUserId', isEqualTo: core.getCurrentUser().userId)
          .getDocuments();

      if (user.documents.length > 0) {
        users = _usersInstance
            .document(user.documents.first.documentID)
            .collection("conversations")
            .orderBy('time', descending: true)
            .snapshots();

        setState(() {});
      }
    } catch (e) {
      print(e.message);
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
          if (value.length > 2) {
            searchUser(value);
          }
        }));
  }

  void searchUser(String searchString) async {
    core.startLoading(_context);
    ResponseUsers response;
    try {
      response = await core.searchUsers(searchString, 0);
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
        setState(() {
          serachUsers = response.payload;
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

class FirebaseUser {
  String id;
  String mobile;
  String country;
  String Occupation;
  String thumb;
  num time;
  String name;
  bool isPro;

  FirebaseUser(
      {String id,
      String mobile,
      String country,
      String Occupation,
      String thumb,
      num time,
      String name,
      bool isPro}) {
    this.id = id;
    this.mobile = mobile;
    this.country = country;
    this.Occupation = Occupation;
    this.thumb = thumb;
    this.time = time;
    this.name = name;
    this.isPro = isPro;
  }

  FirebaseUser.fromData(DocumentSnapshot snapshot) {
    this.id = snapshot.data["id"];
    this.mobile = snapshot.data["mobile"];
    this.country = snapshot.data["country"];
    this.Occupation = snapshot.data["occupation"];
    this.thumb = snapshot.data["thumb"];
    this.time = snapshot.data["time"];
    this.name = snapshot.data["name"];
    this.isPro = snapshot.data["isPro"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'country': country,
      'Occupation': Occupation,
      'thumb': thumb,
      'time': time,
      'name': name,
      'isPro': isPro,
    };
  }
}
