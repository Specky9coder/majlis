import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityGoPro.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/AlMajlisAvailabilityDays.dart';

import 'package:almajlis/core/constants/TimeZoneConstants.dart';
import 'package:almajlis/core/wrappers/AlMajlisTimeZones.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';
import 'package:almajlis/views/components/AlMajlisTimePicker.dart';

import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityPro extends StatefulWidget {
  bool fromSeetings;

  ActivityPro({Key key, this.fromSeetings = true}) : super(key: key);

  @override
  _ActivityProState createState() => _ActivityProState();
}

class _ActivityProState extends ActivityStateBase<ActivityPro> {
  TextEditingController benifitPayNoController = TextEditingController();
  TextEditingController callTitleController = TextEditingController();
  TextEditingController meetingChargesController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  List<bool> selectedValue = [true, false];
  List<bool> selectDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  BuildContext _context;
  User user;
  int selectedFromTime;
  int selectedToTime;
  bool isPro = false;
  GlobalKey _key;
  bool isSelected = false;
  final scaffoldState = GlobalKey<ScaffoldState>();
  AnimationController _animationController;
  BorderRadius _borderRadius;
  String selectedCallTimeZone;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;

  // bool hasOccupation = false;
  OverlayEntry callDurationOverlay;
  IconData iconDropDown = Icons.keyboard_arrow_down;
  AlMajlisTimeZones timeZone;
  List<String> timeZonesList = List();
  String timeZoneValue;
  String timeZoneName;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    timeZone = AlMajlisTimeZones.fromMap(timeZones);
    for (int index = 0; index < timeZone.timeZones.length; index++) {
      timeZonesList.add(timeZone.timeZones.elementAt(index).text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      isPro
          ? Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Visibility(
                          visible: widget.fromSeetings,
                          child: AlMajlisBackButton(
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AlMajlisTextViewBold(
                              "Majlis Pro",
                              size: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: AlMajlisTextViewBold(
                            "SAVE",
                            size: 16,
                            color: Constants.COLOR_PRIMARY_TEAL,
                          ),
                          onTap: editUser,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    AlMajlisTextField(
                      "IBAN/Benefit Pay no.",
                      benifitPayNoController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: AlMajlisTextField(
                        "Call Title",
                        callTitleController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    AlMajlisTextViewBold(
                                      "Call duration",
                                      size: 16.0,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      ToggleButtons(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: AlMajlisTextViewBold(
                                              "30 min",
                                              color: selectedValue[0]
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0, horizontal: 8),
                                            child: AlMajlisTextViewBold(
                                              "60 min",
                                              color: selectedValue[1]
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                        fillColor: Colors.white,
                                        borderColor: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        isSelected: selectedValue,
                                        onPressed: (index) {
                                          List<bool> selected = [
                                            false,
                                            false,
                                          ];
                                          setState(() {
                                            selectedValue = selected;
                                            selected[index] = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    AlMajlisTextViewBold(
                                      "Meeting Charges(BD)",
                                      size: 16.0,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AlMajlisTextField(
                                    "Charges",
                                    meetingChargesController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                    //     child: Container(
                    //       width: double.infinity,
                    //       height: 50.0,
                    //       key: _key,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //             width: 1.0,
                    //             color: Constants.COLOR_PRIMARY_GREY),
                    //         borderRadius: BorderRadius.all(Radius.circular(
                    //                 10.0) //         <--- border radius here
                    //             ),
                    //         color: Colors.transparent,
                    //       ),
                    //       child: IconButton(
                    //         icon: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: <Widget>[
                    //             Padding(
                    //               padding: const EdgeInsets.all(4.0),
                    //               child: AlMajlisTextViewBold(
                    //                 null != selectedCallTimeZone &&
                    //                         !selectedCallTimeZone.isEmpty
                    //                     ? selectedCallTimeZone
                    //                     : "Call Time Zone",
                    //                 size: 16,
                    //               ),
                    //             ),
                    //             Icon(
                    //               iconDropDown,
                    //               size: 20,
                    //             )
                    //           ],
                    //         ),
                    //         color: Colors.white,
                    //         onPressed: () {
                    //           if (isMenuOpen) {
                    //             closeMenu();
                    //           } else {
                    //             openMenu();
                    //           }
                    //           setState(() {
                    //             iconDropDown = isMenuOpen
                    //                 ? Icons.keyboard_arrow_up
                    //                 : Icons.keyboard_arrow_down;
                    //           });
                    //         },
                    //       ),
                    //     )),
                    AlMajlisTextViewBold(
                      "Availability",
                      size: 16.0,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          dayRow("SUN", 0),
                          dayRow("MON", 1),
                          dayRow("TUE", 2),
                          dayRow("WED", 3),
                          dayRow("THU", 4),
                          dayRow("FRI", 5),
                          dayRow("SAT", 6),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AlMajlisTimePicker(
                                "From",
                                onFromTimeChanged,
                                controller: fromDateController,
                                initialTime: selectedFromTime,
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: AlMajlisTimePicker(
                                "To",
                                onToTimeChanged,
                                controller: toDateController,
                                initialTime: selectedToTime,
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AlMajlisBackButton(
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: AlMajlisTextViewBold(
                              "You are not a Pro User yet, GO PRO to avail exiting benefits",
                              size: 16,
                              maxLines: 2,
                              align: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: AlMajlisButton(
                        "GO PRO",
                        Constants.TEAL,
                        () async {
                          //TODO: Check here for in app purchases using apple pay
                          var data = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActivityGoPro(user),
                            ),
                          );
                          if (data != null) {
                            if (data) {
                              getUser();
                            }
                            Fluttertoast.showToast(
                                msg: data
                                    ? "Payment Success"
                                    : "Payment Failure",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2);
//                            showDialog(
//                                context: _context,
//                                builder: (BuildContext context) {
//                                  return DialogSuccessFailure(data
//                                      ? "Payment Success"
//                                      : "Payment Failure");
//                                });
                          }
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    callDurationOverlay.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
    setState(() {
      iconDropDown = Icons.keyboard_arrow_down;
    });
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    callDurationOverlay = _callTimeZoneOverlayBuilder();
    Overlay.of(context).insert(callDurationOverlay);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _callTimeZoneOverlayBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff434343), //widget.backgroundColor,
                    borderRadius: _borderRadius,
                  ),
                  child: Column(
                    children: List.generate(
                      timeZonesList.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCallTimeZone = timeZonesList[index];
                            });
                            closeMenu();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 4.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    timeZonesList[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                index != timeZonesList.length - 1
                                    ? Divider(
                                        height: 2,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onCallTImeZoneChanged(index) {
    selectedCallTimeZone = timeZonesList[index];
    // if (!hasOccupation) {
    //   setState(() {
    //     // progress += 1;
    //     // hasOccupation = true;
    //   });
    // }
  }

  Padding dayRow(String day, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (selectDay[index] == false) {
                selectDay[index] = true;
              } else {
                selectDay[index] = false;
              }
            });
          },
          child: CircleAvatar(
            radius: 19,
            backgroundColor: selectDay[index] ? Colors.white : Colors.black,
            child: AlMajlisTextViewBold(
              day,
              color: selectDay[index] ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
      //),
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
    }

    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        user = response.payload;
        // print(user.timeZone);
        // print(user.timeZoneName);
        setState(() {
          if (null != user.isPro) {
            isPro = user.isPro;
          }
          if (null != user.iban && !user.iban.isEmpty) {
            benifitPayNoController.text = user.iban;
          }
          if (null != user.callTitle && !user.callTitle.isEmpty) {
            callTitleController.text = user.callTitle;
          }
          if (null != user.callDuration && user.callDuration > 0) {
            if (user.callDuration == 30) {
              selectedValue[0] = true;
              selectedValue[1] = false;
            } else {
              selectedValue[0] = false;
              selectedValue[1] = true;
            }
          }
          if (null != user.availabilityDays) {
            selectDay[0] = user.availabilityDays.sun;
            selectDay[1] = user.availabilityDays.mon;
            selectDay[2] = user.availabilityDays.tue;
            selectDay[3] = user.availabilityDays.wed;
            selectDay[4] = user.availabilityDays.thu;
            selectDay[5] = user.availabilityDays.fri;
            selectDay[6] = user.availabilityDays.sat;
          }
          if (null != user.availabilityStart && user.availabilityStart > 0) {
            selectedFromTime = user.availabilityStart;
            num minutes = ((selectedFromTime / 60) % 60).round();
            num hours =
                (((selectedFromTime / 60) - ((selectedFromTime / 60) % 60)) /
                        60)
                    .round();

            String timeMeridian = "AM";
            if (hours > 12) {
              timeMeridian = "PM";
              hours = hours - 12;
            }

            String hoursString = hours.toString();
            if (hours < 10) {
              hoursString = "0" + hoursString;
            }
            String minuteString = minutes.toString();
            if (minutes < 10) {
              minuteString = "0" + minuteString;
            }

            fromDateController.text =
                hoursString + ":" + minuteString + " " + timeMeridian;
          }
          if (null != user.availabilityEnd && user.availabilityEnd > 0) {
            var date = new DateTime.fromMillisecondsSinceEpoch(
                user.availabilityEnd * 1000);
            print(date);
            selectedToTime = user.availabilityEnd;
            num minutes = ((selectedToTime / 60) % 60).round();
            num hours =
                (((selectedToTime / 60) - ((selectedToTime / 60) % 60)) / 60)
                    .round();
            String timeMeridian = "AM";
            if (hours > 12) {
              timeMeridian = "PM";
              hours = hours - 12;
            }
            String hoursString = hours.toString();
            if (hours < 10) {
              hoursString = "0" + hoursString;
            }
            String minuteString = minutes.toString();
            if (minutes < 10) {
              minuteString = "0" + minuteString;
            }
            toDateController.text =
                hoursString + ":" + minuteString + " " + timeMeridian;
          }
          if (null != user.meetingCharges) {
            meetingChargesController.text = user.meetingCharges.toString();
          }
        });
      }
    }
    core.stopLoading(_context);
  }

  void editUser() async {
    AlMajlisAvailabilityDays availableDays = AlMajlisAvailabilityDays()
      ..sun = selectDay[0]
      ..mon = selectDay[1]
      ..tue = selectDay[2]
      ..wed = selectDay[3]
      ..thu = selectDay[4]
      ..fri = selectDay[5]
      ..sat = selectDay[6];

    user
      ..iban = benifitPayNoController.text
      ..callTitle = callTitleController.text
      ..availabilityStart = selectedFromTime
      ..availabilityEnd = selectedToTime
      ..availabilityDays = availableDays
      ..meetingCharges = num.parse(meetingChargesController.text)
      ..timeZone = timeZoneValue
      ..timeZoneName = timeZoneName
      ..callDuration = selectedValue[0] ? 30 : 60;

    print(selectedFromTime);

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
    }
    core.stopLoading(_context);

    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        core.updateSession(core.getToken(), user);
        print("in success");
        Navigator.pop(context);
      }
    }
  }

  onToTimeChanged(TimeOfDay time) {
    int minutes = 0;
    if (time.hour > 12) {
      int hours = 0;
      hours = time.hour - 12;
      minutes = 720 + (hours * 60);
    } else {
      minutes = time.hour * 60;
    }
    minutes += time.minute;
    setState(() {
      selectedToTime = minutes * 60;
      print(selectedToTime);
    });
  }

  onFromTimeChanged(TimeOfDay time) {
    int minutes = 0;
    if (time.hour > 12) {
      int hours = 0;
      hours = time.hour - 12;
      minutes = 720 + (hours * 60);
    } else {
      minutes = time.hour * 60;
    }
    minutes += time.minute;
    setState(() {
      selectedFromTime = minutes * 60;
    });
  }

  checkTImeZone() async {
    var now = DateTime.now();
    var timeZoneOffset = now.timeZoneOffset;
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
//    var timeZoneHr= now.timeZoneOffset.inHours;
//    int timeZoneMin = (now.timeZoneOffset.inMinutes/10).round();
    var timeZonehr = now.timeZoneOffset.inHours.toString() +
        ":" +
        (now.timeZoneOffset.inMinutes / 10).round().toString();
    print("timeZonehr-->" + timeZonehr);
    String timezoneName =
        "(UTC " + timeZonehr.toString() + ") " + currentTimeZone;
    timeZoneValue = timeZoneOffset.toString();
    timeZoneName = timezoneName;
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser();
    checkTImeZone();
  }
}
