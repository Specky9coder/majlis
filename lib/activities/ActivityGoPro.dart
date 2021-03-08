import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityCreditCardPayment.dart';
import 'package:almajlis/core/server/wrappers/ResponseUtils.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlMajlisRadioButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityGoPro extends StatefulWidget {
  User user;

  ActivityGoPro(this.user, {Key key}) : super(key: key);

  @override
  _ActivityGoProState createState() => _ActivityGoProState();
}

class _ActivityGoProState extends ActivityStateBase<ActivityGoPro> {
  List<RadioModel> radioBtnData = new List<RadioModel>();
  num proCharges = 0;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    radioBtnData.add(
      new RadioModel(false, 'To job search with confidence'),
    );
    radioBtnData.add(
      new RadioModel(false, 'To grow my connections and \n business'),
    );
    radioBtnData.add(
      new RadioModel(false, 'To find contacts and talents \n more effectively'),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlMajlisBackButton(
                onClick: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AlMajlisTextViewBold(
                    "Upgrade to \nAlMajlis Pro",
                    size: 28,
                  ),
                  null != widget.user.thumbUrl && !widget.user.thumbUrl.isEmpty
                      ? AlMajlisProfileImageWithStatus(
                          widget.user.thumbUrl,
                          30.0,
                          isPro: widget.user.isPro,
                        )
                      : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.user.isPro
                                  ? Constants.COLOR_PRIMARY_TEAL
                                  : Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.purple, Colors.teal],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Hey ',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.user.firstName +
                            " " +
                            widget.user.lastName +
                            "!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: ' How would you like AlMajlis Pro to help you?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: radioBtnData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: InkWell(
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          setState(() {
                            if (radioBtnData[index].isSelected) {
                              radioBtnData[index].isSelected = false;
                            } else {
                              radioBtnData[index].isSelected = true;
                            }
                          });
                        },
                        child: new RadioItem(radioBtnData[index], Colors.black),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.only(bottom: 32.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Constants.COLOR_DARK_GREY,
                ),
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AlMajlisTextViewSemiBold(
                                "PRO FEATURES",
                                size: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child:
                                    AlMajlisImageIcons("drawables/go_pro.png"),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: proCharges.toString() + ' BD',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.COLOR_PRIMARY_TEAL,
                                ),
                              ),
                              TextSpan(
                                text: '/ 3 MONTHS',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AlMajlisProFeatureCardRow("Highlighted posts"),
                    AlMajlisProFeatureCardRow("Highlighted profile"),
                    AlMajlisProFeatureCardRow("Priority in search"),
                    AlMajlisProFeatureCardRow("Enable specialised booking"),
                    AlMajlisProFeatureCardRow("Receive payments"),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Constants.COLOR_DARK_TEAL,
                    ),
                    height: 50.0,
                    child: Center(
                      child: MaterialButton(
                          child: AlMajlisTextViewBold(
                            "CONTINUE TO PAYMENT",
                            size: 16,
                          ),
                          onPressed: () async {
                            var data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityCreditCardPayment(
                                  proCharges,
                                  isBooking: false,
                                ),
                              ),
                            );
//                            print(data != null && data
//                                ? "4. SUCESSFULL bought subscription"
//                                : "Not SUCESSFULL");
                            Navigator.pop(context, data);
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: AlMajlisTextViewRegular(
                      "This is an ongoing paid plan. By proceeding, you agree \n     to be charged monthly. You can cancel anytime.",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getUtils() async {
    core.startLoading(_context);
    ResponseUtils response;
    try {
      response = await core.getUtils();
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
                    getUtils();
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
          if (null != response.payload.proSubscriptionCharge) {
            proCharges = response.payload.proSubscriptionCharge;
          }
        });
      }
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUtils();
  }
}

class AlMajlisProFeatureCardRow extends StatelessWidget {
  final String title;

  AlMajlisProFeatureCardRow(
    this.title, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.done,
            size: 14.0,
            color: Constants.COLOR_DARK_TEAL,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 2.0, left: 5.0),
            child: AlMajlisTextViewRegular(
              title,
              size: 14,
              color: Colors.grey,
              // weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
