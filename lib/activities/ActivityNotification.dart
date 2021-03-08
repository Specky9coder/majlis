import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityBookings.dart';

import 'package:almajlis/activities/ActivitySearch.dart';

import 'package:almajlis/activities/index.dart';
import 'package:almajlis/core/server/wrappers/ResponseBookings.dart';
import 'package:almajlis/core/server/wrappers/ResponseNotifications.dart';

import 'package:almajlis/core/wrappers/AlMajlisNotification.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/MyMeetingsBottomSheet.dart';

import 'package:almajlis/views/components/AlMajlisNotificationTile.dart';

import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';

import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivityNotificaton extends StatefulWidget {
  ActivityNotificaton({Key key}) : super(key: key);

  @override
  _ActivityNotificatonState createState() => _ActivityNotificatonState();
}

class _ActivityNotificatonState extends ActivityStateBase<ActivityNotificaton> {
  TextEditingController searchController = TextEditingController();
  bool isSearchBtnClicked = false;
  List<String> dropdownOptions = ["All", "Contacts only", "AlMajlis Pro"];
  OverlayEntry dropDownOverlay;
  String dropDownString;
  IconData iconDropDown = Icons.keyboard_arrow_down;
  BorderRadius _borderRadius;
  AnimationController _animationController;
  String selectedItem;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  GlobalKey _key;
  BuildContext _context;
  List<AlMajlisNotification> notifications = List();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final scaffoldState = GlobalKey<ScaffoldState>();
  List<Booking> meetings = List();
  int actualLength = 0;
  int notificationLength = 0;
  List<User> serachUsers = List();
  Timer searchOnStoppedTyping;
  bool isVideoCallDone = false;
  bool fetchMore = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    notificationLength = 0;
    if (meetings.length > 0) {
      notificationLength = 1;
      actualLength = 1;
    }
    notificationLength += notifications.length;
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        body: WillPopScope(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // isSearchBtnClicked = true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivitySearch()),
                                );
                              });
                            },
                            child: AlMajlisRoundIconButton(
                              "drawables/search_bar.png",
                              isSelected: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 16, top: 16, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AlMajlisTextViewBold(
                            "Notifications",
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () {
                          getNotifications(DateTime.now(),
                              isPulltorefresh: true);
                        },
                        child: loading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor:
                                        Constants.COLOR_PRIMARY_TEAL_OPACITY),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: notificationLength,
                                itemBuilder: (BuildContext context, int index) {
                                  if (meetings.length > 0 && index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'My Meetings',
                                                  style: TextStyle(
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          "ProximaNovaBold",
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: CircleAvatar(
                                                      radius: 12.0,
                                                      child:
                                                          AlMajlisTextViewSemiBold(
                                                        meetings.length
                                                            .toString(),
                                                        size: 16,
                                                      ),
                                                      backgroundColor: Constants
                                                          .COLOR_DARK_TEAL,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityBookings(),
                                                ),
                                              );
                                            },
                                            child:
                                                AlMajlisTextViewBold("SEE ALL"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  if (null !=
                                          notifications
                                              .elementAt(index - actualLength)
                                              .dateType &&
                                      notifications
                                              .elementAt(index - actualLength)
                                              .dateType ==
                                          1) {
                                    return Padding(
                                      padding: notifications
                                                  .elementAt(
                                                      index - actualLength)
                                                  .datstring ==
                                              "TODAY"
                                          ? const EdgeInsets.only(top: 8.0)
                                          : const EdgeInsets.only(top: 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        color: Constants.COLOR_DARK_GREY,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Row(
                                            children: <Widget>[
                                              AlMajlisTextViewBold(
                                                notifications
                                                    .elementAt(
                                                        index - actualLength)
                                                    .datstring,
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  bool hasDivider = true;
                                  if (index - actualLength + 1 <
                                          notifications.length &&
                                      null !=
                                          notifications
                                              .elementAt(
                                                  index - actualLength + 1)
                                              .dateType &&
                                      notifications
                                              .elementAt(
                                                  index - actualLength + 1)
                                              .dateType ==
                                          1) {
                                    hasDivider = false;
                                  }

                                  if (index == notificationLength - 4) {
                                    if (fetchMore) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        getNotifications(
                                            notifications
                                                .elementAt(
                                                    notifications.length - 1)
                                                .createdAt,
                                            isNonPaginationCall: false);
                                      });
                                    }
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: index == notificationLength - 1
                                            ? 100
                                            : 0),
                                    child: AlMajlisNotificationTile(
                                      notifications
                                          .elementAt(index - actualLength),
                                      hasDivider: hasDivider,
                                    ),
                                  );
                                }),
                      ),
                    ),
                  ],
                ),

                // Container(
                //   height: double.infinity,
                //   width: double.infinity,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: <Widget>[
                //       AlMajlisNavigationBar(2, refreshFunction)
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          onWillPop: () {
            if (isMenuOpen) closeMenu();
            // return;
          },
        ), //
      ),
    );
  }

  void clickVideoCall(index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndexPage(
          meetings.elementAt(index),
        ),
      ),
    );
  }

  refreshFunction() {
    getNotifications(
      new DateTime.now(),
    );
    getMeetings();
  }

  _onChangeHandler(String value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
      () => searchOnStoppedTyping = new Timer(duration, () {
        if (value.length > 2) {}
      }),
    );
  }

  void clickMenu(index) {
    scaffoldState.currentState.showBottomSheet(
      (context) => MyMeetingsBottomSheet(),
    );
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    dropDownOverlay.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
    setState(() {
      iconDropDown = Icons.keyboard_arrow_down;
    });
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    dropDownOverlay = _dropDownOverlayBuilder();
    Overlay.of(context).insert(dropDownOverlay);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _dropDownOverlayBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF434343), //widget.backgroundColor,
                    borderRadius: _borderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      dropdownOptions.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            onListItemChanged(index);
                            String s = dropdownOptions[index];
                            dropDownString = s;
                            closeMenu();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    dropdownOptions[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                (index == dropdownOptions.length - 1)
                                    ? Container()
                                    : Divider(
                                        color: Constants.COLOR_PRIMARY_GREY,
                                        thickness: 2.5,
                                      ),
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

  onListItemChanged(index) {
    setState(() {
      selectedItem = dropdownOptions[index];
    });
  }

  void getNotifications(DateTime date,
      {bool isPulltorefresh = false, bool isNonPaginationCall = true}) async {
    if (!isPulltorefresh) {
      // core.startLoading(_context);
      setState(() {
        loading = true;
      });
    }
    ResponseNotifications response;
    try {
      response = await core.getNotifications(date);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      if (!isPulltorefresh) {
        // core.stopLoading(_context);
        setState(() {
          loading = false;
        });
      } else {
        _refreshController.refreshCompleted();
      }
    } catch (_) {
      if (!isPulltorefresh) {
        // core.stopLoading(_context);
        setState(() {
          loading = false;
        });
      } else {
        _refreshController.refreshCompleted();
      }
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getNotifications(date);
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    if (!isPulltorefresh) {
      // core.stopLoading(_context);
      setState(() {
        loading = false;
      });
    } else {
      _refreshController.refreshCompleted();
    }
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        _refreshController.refreshCompleted();
        bool todayDone = false;
        bool yesterdayDone = false;
        bool olderDone = false;
        if (response.payload.length == 0) {
          fetchMore = false;
        }
        setState(() {
          if (isNonPaginationCall) {
            notifications = response.payload;
            for (int index = 0; index < notifications.length; index++) {
              if (notifications.elementAt(index).createdAt.month ==
                      DateTime.now().month &&
                  notifications.elementAt(index).createdAt.day ==
                      DateTime.now().day &&
                  notifications.elementAt(index).createdAt.year ==
                      DateTime.now().year) {
                if (!todayDone) {
                  AlMajlisNotification notification = AlMajlisNotification()
                    ..dateType = 1
                    ..datstring = "TODAY";
                  notifications.insert(index, notification);
                  todayDone = true;
                }
              } else if (notifications.elementAt(index).createdAt.month ==
                      DateTime.now().month &&
                  notifications.elementAt(index).createdAt.day ==
                      DateTime.now().day - 1 &&
                  notifications.elementAt(index).createdAt.year ==
                      DateTime.now().year) {
                if (!yesterdayDone) {
                  AlMajlisNotification notification = AlMajlisNotification()
                    ..dateType = 1
                    ..datstring = "YESTERDAY";
                  notifications.insert(index, notification);
                  yesterdayDone = true;
                }
              } else {
                AlMajlisNotification notification = AlMajlisNotification()
                  ..dateType = 1
                  ..datstring = "OLDER";
                notifications.insert(index, notification);
                olderDone = true;
                break;
              }
            }
          } else {
            notifications.addAll(response.payload);
          }
        });
      }
    }
  }

  void getMeetings() async {
    // core.startLoading(_context);
    setState(() {
      loading = true;
    });
    ResponseBookings response;
    try {
      response = await core.getBookings();
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      // core.stopLoading(_context);
      setState(() {
        loading = false;
      });
    } catch (_) {
      // core.stopLoading(_context);
      setState(() {
        loading = false;
      });
      showDialog(
          context: _context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: AlMajlisTextViewBold(
                  "Unable To Connect To Server, Please try again"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    getMeetings();
                    Navigator.of(context).pop();
                  },
                  child: new Text("Try Again"),
                  color: Colors.teal,
                ),
              ],
            );
          });
    }

    // core.stopLoading(_context);
    setState(() {
      loading = false;
    });
    if (!core.systemCanHandel(response)) {
      if (response.status.statusCode == 0) {
        setState(() {
          meetings = response.payload;
          if (meetings.length > 0) {
            if (meetings.elementAt(0).call_status == 2) {
              isVideoCallDone = true;
            }
          }
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getNotifications(DateTime.now());
    getMeetings();
  }
}

class AlMajlisRoundIconButton extends StatelessWidget {
  var icon;

  AlMajlisRoundIconButton(
    this.icon, {
    Key key,
    @required this.isSelected,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Constants.COLOR_PRIMARY_TEAL
                : Constants.COLOR_DARK_GREY),
        child: Image.asset(
          icon,
          height: 20,
        ),
      ),
    );
  }
}
