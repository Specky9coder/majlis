import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityBookings.dart';
import 'package:almajlis/activities/ActivityPhoneNumber.dart';
import 'package:almajlis/activities/ActivityPro.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivitySettings extends StatefulWidget {
  @override
  _ActivitySettingsState createState() => _ActivitySettingsState();
}

class _ActivitySettingsState extends ActivityStateBase<ActivitySettings> {
  bool toogleValue = false;
  List<bool> selectedValue = [true, false];
  User user;
  BuildContext _context;

  String phoneNumber = "";
  String imageUrl = "";
  bool isPro = false;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AlMajlisTextViewBold(
                  "Settings",
                  size: 32,
                ),
                null != imageUrl && !imageUrl.isEmpty
                    ? AlMajlisProfileImageWithStatus(
                        imageUrl,
                        50.0,
                        isPro: isPro,
                      )
                    : Container(
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
                                gradient: LinearGradient(
                                    colors: [Colors.purple, Colors.teal])),
                          ),
                        ),
                      ),
              ],
            ),
//            Padding(
//              padding: const EdgeInsets.only(top:16.0),
//              child: AlMajlisSettingsRow(
//                  "Language",
//                  "drawables/Mask Group 63.png",
//                  <Widget>[
//                    ToggleButtons(
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.all(2.0),
//                          child: AlMajlisTextViewBold(
//                            "English",
//                            color: selectedValue[0] ? Colors.black: Colors.white,
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(2.0),
//                          child: AlMajlisTextViewBold(
//                            "اَلْفُصْحَىٰ",
//                            color: selectedValue[1] ? Colors.black: Colors.white,
//                          ),
//                        ),
//                      ],
//                      fillColor: Colors.white,
//                      borderColor: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                      isSelected: selectedValue,
//                      onPressed: (index) {
//                        List<bool> selected = [false, false];
//                        setState(() {
//                          selectedValue = selected;
//                          selected[index] = true;
//                        });
//                      },
//                    )
//                  ]
//              ),
//            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: GestureDetector(
                child: AlMajlisSettingsRow(
                    "Phone Number", "drawables/calls.png", <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AlMajlisTextViewMedium(phoneNumber),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )
                ]),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivityPhoneNumber(user)));
                  getUser();
                },
              ),
            ),
//            AlMajlisSettingsRow(
//                "Option with toggle",
//                "drawables/Mask Group 65.png",
//                <Widget>[
//                  Switch(
//                    value: toogleValue,
//                    onChanged: (value) {
//                    setState(() {
//                      toogleValue = value;
//                    });
//                  },
//                    activeColor: Colors.green,
//                    inactiveTrackColor: Constants.COLOR_PRIMARY_GREY,
//                  )
//                ]
//            ),
            GestureDetector(
              child: AlMajlisSettingsRow(
                  "Majlis Pro", "drawables/go_pro.png", <Widget>[
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ]),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ActivityPro()));
              },
            ),
            GestureDetector(
              child: AlMajlisSettingsRow(
                  "My Meetings", "drawables/go_pro.png", <Widget>[
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ]),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ActivityBookings()));
              },
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: Colors.transparent,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.assignment_return,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Center(
                                    child: AlMajlisTextViewBold("LOG OUT ",
                                        color: Colors.red, size: 16),
                                  ),
                                )
                              ],
                            )),
                      ),
                      onTap: () {
                        core.logout(_context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
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
        backgroundColor: Colors.black,
      ),
    );
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
          if (null != user.phone_number && !user.phone_number.isEmpty) {
            phoneNumber = user.phone_number;
          }
          if (null != user.isPro) isPro = user.isPro;
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

class AlMajlisSettingsRow extends StatelessWidget {
  String image;
  String title;
  List<Widget> childrens = new List();
  AlMajlisSettingsRow(
    this.title,
    this.image,
    this.childrens, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                image,
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlMajlisTextViewBold(
                  title,
                  size: 16,
                  weight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: childrens,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              color: Constants.COLOR_PRIMARY_GREY,
              thickness: 2.5,
            ),
          )
        ],
      ),
    );
  }
}
