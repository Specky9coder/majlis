import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';

import 'package:almajlis/activities/index.dart';
import 'package:almajlis/core/server/wrappers/ResponseBooking.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityVideoCallOperationsScreen extends StatefulWidget {

  String id;
  ActivityVideoCallOperationsScreen(this.id);
  @override
  _ActivityVideoCallOperationsScreenState createState() => _ActivityVideoCallOperationsScreenState();
}

class _ActivityVideoCallOperationsScreenState extends ActivityStateBase<ActivityVideoCallOperationsScreen> {

  BuildContext _context;
  Booking booking;
  String thumbUrl = "";
  String name = "";
  bool isPro = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    print(booking);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    null != thumbUrl && !thumbUrl.isEmpty
                        ? AlMajlisProfileImageWithStatus(
                      thumbUrl,
                      100.0,
                      isPro: isPro,
                    )
                        : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPro ? Constants.COLOR_PRIMARY_TEAL : Colors.white),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                              LinearGradient(
                                  colors: [
                                    Colors.purple,
                                    Colors.teal
                                  ])),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8),
                      child: AlMajlisTextViewBold(
                          name,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: AlMajlisTextViewMedium(
                        "Calling..",
                        size: 16,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            print(booking.id);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IndexPage(
                                          booking
                                      )),
                            );
                          },
                            child: Image.asset("drawables/answer_call.png", height: 90,)
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                            onTap: declineBooking,
                            child: Image.asset("drawables/hang_call.png", height: 90,)
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void getBookingDetails() async {
    core.startLoading(_context);
    ResponseBooking response;
    try {
      response = await core.getBookingDetails(widget.id);
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
                    getBookingDetails();
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
        print("response" + response.payload.toString());
        if(response.payload.call_status == -1) {
          Navigator.pop(context);
        }
        else {
          setState(() {
            booking = response.payload;
            if(null != booking.bookedFor.thumbUrl) {
              thumbUrl = booking.bookedFor.thumbUrl;
            }
            if(null != booking.bookedFor.isPro) {
              isPro = booking.bookedFor.isPro;
            }
            if(null != booking.bookedFor.firstName && null != booking.bookedFor.lastName) {
              name = booking.bookedFor.firstName + " " + booking.bookedFor.lastName;
            }
          });
        }
      }
    }

  }

  void declineBooking() async {
    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.declineBooking(widget.id);
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
                    declineBooking();
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
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getBookingDetails();
  }
}
