import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityEditProfile.dart';

import 'package:almajlis/core/server/wrappers/ResponseLogin.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';

import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityLogin extends StatefulWidget {
  @override
  _ActivityLoginState createState() => _ActivityLoginState();
}

class _ActivityLoginState extends ActivityStateBase<ActivityLogin> {
  TextEditingController phoneNoController = new TextEditingController();
  TextEditingController pinCode = new TextEditingController();

  String _countryCode = '+973';
  String _countryInitial = "BH";
  String _mobileNumber = "";
  bool otpScreen = false;
  bool isLoading = false;

  TextEditingController firstDigitController = new TextEditingController();
  TextEditingController secondDigitController = new TextEditingController();
  TextEditingController thirdDigitController = new TextEditingController();
  TextEditingController fourthDigitController = new TextEditingController();
  TextEditingController fifthDigitController = new TextEditingController();
  TextEditingController sixthDigitController = new TextEditingController();

  FocusNode secondDigitFocusNode = new FocusNode();
  FocusNode thirdDigitFocusNode = new FocusNode();
  FocusNode fourthDigitFocusNode = new FocusNode();
  FocusNode fifthDigitFocusNode = new FocusNode();
  FocusNode sixthDigitFocusNode = new FocusNode();
  FocusNode sevethFocusNode = new FocusNode();

  String smsOTP;
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  String errorText;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_countryCode);
    print(_countryInitial);
    return AlMajlisBackground(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: otpScreen
            ? Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              otpScreen = !otpScreen;
                            });
                          },
                          child: AlMajlisTextViewBold("CANCEL", size: 12),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: <Widget>[
                        AlMajlisTextViewBold("Verify your",
                            size: 34,
                            color: Colors.white,
                            weight: FontWeight.bold),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      AlMajlisTextViewBold("phone number",
                          size: 34,
                          color: Colors.white,
                          weight: FontWeight.bold),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: AlMajlisTextViewBold(
                            "To complete your sign up, please enter the verification code sent to " +
                                _mobileNumber,
                            maxLines: 3,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Container(
                            child: Center(
                              child: Loading(
                                  indicator: BallPulseIndicator(),
                                  size: 30.0,
                                  color: Constants.COLOR_PRIMARY_TEAL),
                            ),
                          )
                        : Center(
                            child: otpWidget(),
                          ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AlMajlisButton(
                                "Verify", Constants.TEAL, completeVerification),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "OTP Sent again",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2);
                            _sigInWithPhoneAuth();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Didn’t receive an SMS code yet?",
                              style: TextStyle(
                                  fontFamily: 'ProximaNovaMedium',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' RESEND',
                                  style: TextStyle(
                                      fontFamily: 'ProximaNovaBold',
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            AlMajlisTextViewBold("Verify your",
                                size: 34,
                                color: Colors.white,
                                weight: FontWeight.bold),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            AlMajlisTextViewBold("phone number",
                                size: 34,
                                color: Colors.white,
                                weight: FontWeight.bold),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: AlMajlisTextViewMedium(
                              "You will receive an SMS code for verification. Message and data rates may apply.",
                              maxLines: 3,
                              size: 16,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Container(
                            child: Center(
                              child: Loading(
                                  indicator: BallPulseIndicator(),
                                  size: 30.0,
                                  color: Constants.COLOR_PRIMARY_TEAL),
                            ),
                          )
                        : Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: new Border.all(
                                      color: Constants.COLOR_PRIMARY_GREY,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CountryCodePicker(
                                    initialSelection: _countryInitial,
                                    onChanged: _onCountryChanged,
                                    textStyle: TextStyle(color: Colors.white),
                                    dialogTextStyle:
                                        TextStyle(color: Colors.teal),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AlMajlisTextField(
                                    "Phone Number",
                                    phoneNoController,
                                    keyboardType: TextInputType.number,
                                    errorText: errorText,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AlMajlisButton("SEND ME AN SMS",
                                Constants.TEAL, _sigInWithPhoneAuth),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "By signing up, you agree to Majlis",
                          style: TextStyle(
                              fontFamily: 'ProximaNovaMedium',
                              color: Colors.white),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunch(
                              "https://majlis.mystaginghub.com/termsandprivacy.html")) {
                            await launch(
                                "https://majlis.mystaginghub.com/termsandprivacy.html");
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Could not launch https://majlis.mystaginghub.com/termsandprivacy.html",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2);
                          }
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                                fontFamily: 'ProximaNovaBold',
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' and',
                                style: TextStyle(
                                    fontFamily: 'ProximaNovaMedium',
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: ' PRIVACY POLICY',
                                style: TextStyle(
                                    fontFamily: 'ProximaNovaBold',
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void _onCountryChanged(CountryCode selectedCountry) {
    setState(() {
      _countryCode = selectedCountry.dialCode;
      _countryInitial = selectedCountry.code;
      core.setCountryName(selectedCountry.name);
    });
  }

  void _sigInWithPhoneAuth() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (phoneNoController.text.isEmpty) {
      setState(() {
        errorText = "Mobile Number Cannot be empty";
      });
    } else {
      setState(() {
        isLoading = true;
        _mobileNumber = _countryCode + phoneNoController.text;
      });
      await _auth.verifyPhoneNumber(
          phoneNumber: _countryCode + phoneNoController.text,
          timeout: const Duration(seconds: 120),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            print(phoneAuthCredential);
            //            FirebaseUser user = await _auth.signInWithCredential(phoneAuthCredential);
            //            onLoginComplete(user);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
//            setState(() {
//              isLoading = false;
//            });
          },
          codeSent: codeSent,
          codeAutoRetrievalTimeout: (String verId) {});
    }
  }

  void codeSent(String verId, [int forceCodeResend]) async {
    verificationId = verId;
    setState(() {
      otpScreen = true;
      isLoading = false;
    });
    String signature = await SmsAutoFill().getAppSignature;
    print('\\\\\\');
    print('\\\\\\');
    print('\\\\\\');
    print('\\\\\\');
    print(signature);
    print('\\\\\\');
    print('\\\\\\');
    print('\\\\\\');
    print('\\\\\\');

    await SmsAutoFill().listenForCode;
  }

  completeVerification() async {
    if (smsOTP.length == 6) {
      try {
        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId,
          smsCode: smsOTP,
        );
        setState(() {
          isLoading = true;
        });
        final FirebaseUser user = await _auth.signInWithCredential(credential);
        onLoginComplete(user);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        switch (e.code) {
          case 'ERROR_INVALID_VERIFICATION_CODE':
            Fluttertoast.showToast(
                msg: "Invalid OTP",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
            break;
          default:
            Fluttertoast.showToast(
                msg: e.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
            break;
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "OTP length shuold be 6 letters",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  void onLoginComplete(FirebaseUser user) async {
    firebaseUser = user;
    String idToken = await firebaseUser.getIdToken();
    print("idToken" + idToken);
    ResponseLogin response = await core.userLogin(idToken);
    print(response);
    if (null != response && null != response.status) {
      if (response.status.statusCode == 0) {
        // update the user session details into shared preferences
        await core.updateSession(
            response.getPayload().token, response.getPayload().user);
        FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

        firebaseMessaging.subscribeToTopic('All');
        String token = await firebaseMessaging.getToken();

        print('\\\\\\\\\\');

        print(token);
        print('\\\\\\\\\\');
        if (core.getCurrentUser().firstName == "" ||
            core.getCurrentUser().firstName == null) {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ActivityEditProfile()));
          Navigator.pop(context, true);
        } else
          Navigator.pop(context, true);
        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (context) => Home()));

      }
    } else {
      // Show generic error for server not returning any data in response
      Fluttertoast.showToast(
          msg: "Server error. Please try again in some time",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }

  Widget otpWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Form(
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 70),
          alignment: Alignment.center,

          child: TextFieldPinAutoFill(
            codeLength: 6,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(color: Colors.red,)
              // ),
              enabled: true,
              enabledBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide:
                    BorderSide(width: 1, color: Constants.COLOR_PRIMARY_GREY),
              ),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide:
                    BorderSide(width: 5, color: Constants.COLOR_PRIMARY_GREY),
              ),
            ),
            currentCode: smsOTP,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 6.0,
            ),
            onCodeSubmitted: (v) {
              smsOTP = v;
            },
            onCodeChanged: (value) {
              print("value $value");
              if (value.length == 6) {
                FocusScope.of(context).requestFocus(
                  FocusNode(),
                );
              }
              smsOTP = value;
            },
          ),
          // child: PinCodeTextField(
          //   length: 6,
          //   obsecureText: false,
          //   animationType: AnimationType.fade,
          //   validator: (v) {
          //     if (v.length < 3) {
          //       return "I'm from validator";
          //     } else {
          //       return null;
          //     }
          //   },
          //   //TODO Change colors
          //   pinTheme: PinTheme(
          //     inactiveColor: Colors.white,
          //     inactiveFillColor: Colors.black,
          //     activeFillColor: Colors.black,
          //     selectedFillColor: Constants.COLOR_DARK_GREY,
          //     activeColor: Colors.white,
          //     selectedColor: Colors.white,
          //     disabledColor: Color(0XFFEDEDED),
          //     shape: PinCodeFieldShape.box,
          //     borderRadius: BorderRadius.circular(10),
          //     fieldHeight: 50,
          //     fieldWidth: MediaQuery.of(context).size.width / 10,
          //     // activeFillColor:
          //     // hasError ? Colors.orange : Colors.white,
          //   ),
          //   animationDuration: Duration(milliseconds: 300),
          //   backgroundColor: Colors.transparent,
          //   enableActiveFill: true,
          //   textStyle: TextStyle(color: Colors.white, fontSize: 20),
          //   // errorAnimationController: viewModel.errorController,
          //   // controller: pinCode,
          //   onCompleted: (v) {
          //     setState(() {
          //       smsOTP = v;
          //     });
          //   },
          //   onChanged: (value) {
          //     print("value $value");
          //   },
          //   beforeTextPaste: (text) {
          //     print("Allowing to paste $text");
          //     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //     //but you can show anything you want here, like your pop up saying wrong paste format or etc
          //     return true;
          //   },
          // )
        ),
      ),
    );
  }
}
