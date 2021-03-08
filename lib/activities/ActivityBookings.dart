import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivityUserChat.dart';
import 'package:almajlis/activities/index.dart';
import 'package:almajlis/core/server/wrappers/ResponseBookings.dart';
import 'package:almajlis/core/wrappers/AlMajlisBooking.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewWithVerified.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ActivityBookings extends StatefulWidget {
  @override
  _ActivityBookingsState createState() => _ActivityBookingsState();
}

class _ActivityBookingsState extends ActivityStateBase<ActivityBookings> {
  TextEditingController searchController = TextEditingController();
  BuildContext _context;
  List<Booking> bookings = new List();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0) //         <--- border radius here
                        ),
                    color: Constants.COLOR_DARK_GREY,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        AlMajlisImageIcons("drawables/search_grey.png"),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                                controller: searchController,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'ProximaNovaSemiMedium',
                                    color: Colors.white),
                                onSubmitted: (term) {},
                                textInputAction: TextInputAction.done,
                                decoration: new InputDecoration(
                                  hintText: "Search Bookings",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontFamily: 'ProximaNovaSemiMedium',
                                      color: Constants.COLOR_PRIMARY_GREY),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: bookings.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return bookingListItem(index);
                      }),
                ),
              )
            ],
          ),
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
          "My Meetings",
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

  Padding bookingListItem(int index) {
    Booking booking = bookings.elementAt(index);
    var dateFormat = DateFormat("MMM d ");
    String hour = booking.meetingTime.hour < 10
        ? "0" + booking.meetingTime.hour.toString()
        : booking.meetingTime.hour.toString();
    String min = booking.meetingTime.minute < 10
        ? "0" + booking.meetingTime.minute.toString()
        : booking.meetingTime.minute.toString();
    String date =
        dateFormat.format(booking.meetingTime) + " " + hour + ":" + min;



    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                null != booking.bookedFor.thumbUrl &&
                        !booking.bookedFor.thumbUrl.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityProfile(
                                      userId: booking.bookedFor.userId,
                                    )),
                          );
                        },
                        child: AlMajlisProfileImageWithStatus(
                          booking.bookedFor.thumbUrl,
                          60.0,
                          isPro: booking.bookedFor.isPro,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityProfile(
                                      userId: booking.bookedFor.userId,
                                    )),
                          );
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: booking.bookedFor.isPro
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
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          AlMajlisTextViewWithVerified(
                            booking.bookedFor.firstName +
                                " " +
                                booking.bookedFor.lastName,
                            isVerified: true,
                            size: 16,
                          ),
                          Row(
                            children: <Widget>[
                              AlMajlisTextViewMedium(date),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              AlMajlisTextViewMedium(
                                "+" + booking.bookingAmount.toString() + " BD",
                                color: Colors.grey,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AlMajlisButton(
                    null,
                    Constants.GREY,
                    () {
                      clickMessage(index);
                    },
                    icon: Image.asset(
                      "drawables/message_white-01.png",
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void clickMessage(index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ActivityUserChat(
                myUserId: core.getCurrentUser().userId,
                otherPersonUserId: bookings.elementAt(index).bookedFor.userId,
              )),
    );
  }

  void clickVideoCall(index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IndexPage(bookings.elementAt(index))),
    );
  }

  void getBookings() async {
    core.startLoading(_context);
    ResponseBookings response;
    try {
      response = await core.getBookings();
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
                    getBookings();
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
          bookings = response.payload;
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getBookings();
  }
}
