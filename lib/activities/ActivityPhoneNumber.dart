import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisNavigationBar.dart';
import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityPhoneNumber extends StatefulWidget {

  User user;
  ActivityPhoneNumber(this.user,{Key key}) : super(key: key);

  @override
  _ActivityPhoneNumberState createState() => _ActivityPhoneNumberState();
}

class _ActivityPhoneNumberState extends ActivityStateBase<ActivityPhoneNumber> {
  TextEditingController phoneNumber = TextEditingController();
  bool toogleValue = false;
  BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(null != widget.user.isPublic) {
      toogleValue = widget.user.isPublic;
    }
    if(null != widget.user.phone_number) {
      phoneNumber.text = widget.user.phone_number;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(Padding(
      padding: EdgeInsets.all(20.0),
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
              Expanded(
                child: Center(
                  child: AlMajlisTextViewBold(
                    "Phone Number",
                    size: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: editUser,
                child: AlMajlisTextViewBold(
                  "SAVE",
                  size: 16,
                  color: Constants.COLOR_PRIMARY_TEAL,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          AlMajlisTextViewMedium("Phone Number", size: 16,),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: AlMajlisTextViewBold(phoneNumber.text.toString(), size: 18,),
          ),
//          AlMajlisTextField("Phone Number", phoneNumber),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AlMajlisTextViewBold(
                  "Public",
                  size: 18,
                ),
              ),
              Switch(
                value: toogleValue,
                onChanged: (value) {
                  setState(() {
                    toogleValue = value;
                  });
                },
                activeColor: Colors.green,
                inactiveTrackColor: Constants.COLOR_PRIMARY_GREY,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 20.0, top: 10.0),
            child: AlMajlisTextViewRegular(
              "Make Your Mobile Number Public.",
            ),
          ),
          Divider(
            color: Constants.COLOR_PRIMARY_GREY,
            thickness: 2.5,
          )
        ],
      ),
    ));
  }

  void editUser() async {
    widget.user..isPublic = toogleValue;

    core.startLoading(_context);
    ResponseOk response;
    try {
      response = await core.editUser(widget.user);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      core.stopLoading(_context);
      setState(() {
        toogleValue = !toogleValue;
      });
    } catch (_) {
      core.stopLoading(_context);
      setState(() {
        toogleValue = !toogleValue;
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
                    editUser();
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

      }
      else {
        setState(() {
          toogleValue = !toogleValue;
        });

      }
    }
    else {
      setState(() {
        toogleValue = !toogleValue;
      });
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}
