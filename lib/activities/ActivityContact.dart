import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/core/server/wrappers/ResponseContacts.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/core/wrappers/UserNetwork.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityContact extends StatefulWidget {
  bool isContact;

  ActivityContact({Key key, this.isContact = false}) : super(key: key);

  @override
  _ActivityContactState createState() => _ActivityContactState();
}

class _ActivityContactState extends ActivityStateBase<ActivityContact> {
  List<UserNetwork> users = List();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            User user;
            if (widget.isContact) {
              user = users.elementAt(index).connectedTo;
            } else {
              user = users.elementAt(index).connectedBy;
            }
            String name = "";
            String occupation = "";
            String country = "";
            if (null != user.firstName) {
              name = user.firstName + " ";
            }
            if (null != user.lastName) {
              name += user.lastName;
            }
            if (null != user.country) {
              country += user.country;
            }
            if (null != user.occupation) {
              occupation += user.occupation;
            }
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, bottom: 8.0, right: 8.0),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityProfile(
                        userId: user.userId,
                      ),
                    ),
                  );
                  getContacts();
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              null != user.thumbUrl && !user.thumbUrl.isEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ActivityProfile(
                                                    userId: user.userId),
                                          ),
                                        );
                                        getContacts();
                                      },
                                      child: AlMajlisProfileImageWithStatus(
                                          user.thumbUrl, 70.0,
                                          isPro: user.isPro),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ActivityProfile(
                                              userId: user.userId,
                                            ),
                                          ),
                                        );
                                        getContacts();
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: user.isPro
                                                ? Constants.COLOR_PRIMARY_TEAL
                                                : Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.purple,
                                                  Colors.teal
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityProfile(
                                                  userId: user.userId,
                                                ),
                                              ),
                                            );
                                            getContacts();
                                          },
                                          child: AlMajlisTextViewBold(
                                            name,
                                            size: 16,
                                          ),
                                        ),
                                        AlMajlisTextViewMedium(
                                          occupation,
                                        ),
                                        AlMajlisTextViewMedium(
                                          country,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
//                                Visibility(
//                                  visible: widget.isContact ? false : user.isFollowing,
//                                  child: GestureDetector(
//                                    onTap: () {
//                                      addConnection(user.userId);
//                                    },
//                                    child: AlMajlisImageIcons(
//                                      "drawables/Add_contact-01.png",
//                                      iconHeight: 38,
//                                    ),
//                                  ),
//                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Divider(
                              color: Constants.COLOR_PRIMARY_GREY,
                              thickness: 2.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AlMajlisBackButton(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: AlMajlisTextViewBold(
          widget.isContact ? "Contacts" : "Invites",
          size: 16,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: Center(
        //       child: AlMajlisTextViewBold(
        //         "CLEAR ALL",
        //         color: Constants.COLOR_PRIMARY_TEAL,
        //       ),
        //     ),
        //   ),
        // ],
      ),
    );
  }

  void addConnection(userId) async {
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
        getContacts();
      }
    }
  }

  void getContacts() async {
    core.startLoading(_context);
    ResponseContacts response;
    try {
      if (widget.isContact)
        response = await core.getContacts();
      else
        response = await core.getInvites();
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
                    getContacts();
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
          users = response.payload;
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getContacts();
  }
}
