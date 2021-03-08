import 'dart:async';
import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityPaymentView.dart';
import 'package:almajlis/activities/ActivityPro.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePaymentSuccess.dart';
import 'package:almajlis/core/wrappers/AlMajlisBooking.dart';
import 'package:almajlis/core/wrappers/AlmajlisPurchesProUserRequest.dart';
import 'package:almajlis/ios_in_app_purchase/consumable_store.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/components/AlMajlisButton.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewSemiBold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

const bool kAutoConsume = true;

const String _kConsumableId = '';
const String _kSubscriptionId = 'prosubscription';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  'prosubscription',
  _kSubscriptionId
];

// TODO: Please Add your android product ID here
const List<String> _kAndroidProductIds = <String>[''];
//Example
//const List<String> _kAndroidProductIds = <String>[
//  'ADD_YOUR_ANDROID_PRODUCT_ID_1',
//  'ADD_YOUR_ANDROID_PRODUCT_ID_2',
//  'ADD_YOUR_ANDROID_PRODUCT_ID_3'
//];

// TODO: Please Add your iOS product ID here
const List<String> _kiOSProductIds = <String>['prosubscription'];
//Example
//const List<String> _kiOSProductIds = <String>[
//  'ADD_YOUR_IOS_PRODUCT_ID_1',
//  'ADD_YOUR_IOS_PRODUCT_ID_2',
//  'ADD_YOUR_IOS_PRODUCT_ID_3'
//];

class ActivityCreditCardPayment extends StatefulWidget {
  bool isBooking;
  AlMajlisBooking booking;
  num charges;

  ActivityCreditCardPayment(this.charges,
      {Key key, this.isBooking = false, this.booking})
      : super(key: key);

  @override
  _ActivityCreditCardPaymentState createState() =>
      _ActivityCreditCardPaymentState();
}

class _ActivityCreditCardPaymentState
    extends ActivityStateBase<ActivityCreditCardPayment> {
  BuildContext _context;
  String date;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isBooking) {
      var dateFormat = DateFormat("dd/MM/y");
      String dateString = dateFormat.format(widget.booking.bookingDate);
      String timeMeridian =
          widget.booking.bookingDate.hour > 12 ? " PM" : " AM";
      String hour = widget.booking.bookingDate.hour > 12
          ? (widget.booking.bookingDate.hour - 12).toString()
          : widget.booking.bookingDate.hour.toString();
      if (int.parse(hour) < 10) {
        hour = "0" + hour;
      }

      String minutes = widget.booking.bookingDate.minute.toString();
      if (int.parse(minutes) < 10) {
        minutes = "0" + minutes;
      }
      date = dateString + " " + hour + ":" + minutes + timeMeridian;
    }
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url == Constants.SUCCESS_URL) {
        print("6...");
        Navigator.pop(context, true);
      } else if (url == Constants.FAILURE_URL) {
        print("7...");
        Navigator.pop(context, false);
      }
    });

    //In app
    if (Platform.isIOS) {
      Stream purchaseUpdated =
          InAppPurchaseConnection.instance.purchaseUpdatedStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });
      initStoreInfo();
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlMajlisBackground(
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            widget.isBooking
                ? Container(
                    decoration: BoxDecoration(
                      color: Constants.COLOR_DARK_GREY,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AlMajlisTextViewSemiBold(
                            "SUMMARY",
                            size: 14,
                            color: Colors.white70,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'MEETING CALL',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: "ProximaNovaBold",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: "ProximaNovaBold",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: widget.booking.bookingTitle,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: "ProximaNovaBold",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      null != widget.booking.userThumb &&
                                              !widget.booking.userThumb.isEmpty
                                          ? AlMajlisProfileImageWithStatus(
                                              widget.booking.userThumb, 28.0,
                                              isPro: true)
                                          : Container(
                                              height: 28,
                                              width: 28,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.teal),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: AlMajlisTextViewMedium(
                                          widget.booking.userName,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 2.0),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "drawables/date.png",
                                        height: 20.0,
                                        width: 20.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: AlMajlisTextViewMedium(
                                          date,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AlMajlisTextViewSemiBold(
                                "TOTAL",
                              ),
                              AlMajlisTextViewBold(
                                widget.charges.toString() + " BD",
                                size: 20.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Constants.COLOR_DARK_GREY,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AlMajlisTextViewSemiBold(
                            "SUMMARY",
                            size: 14.0,
                            color: Colors.white70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: 'ALMAJLIS PRO',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: "ProximaNovaBold",
                                            fontWeight: FontWeight.bold)),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 2.0, bottom: 2.0),
                                        child: AlMajlisImageIcons(
                                            "drawables/go_pro.png"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.charges.toString() + ' BD',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: "ProximaNovaBold",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    WidgetSpan(
                                      child: Text(
                                        "/3 Months",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AlMajlisTextViewSemiBold(
                                "TOTAL",
                              ),
                              AlMajlisTextViewBold(
                                widget.charges.toString() + "BD",
                                size: 20.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AlMajlisButton(
                      "CONFIRM & PAY",
                      Constants.TEAL,
                      () {
                        if (!widget.isBooking) {
                          if (Platform.isIOS) {
                            openInAppPurchases();
//                          showDialog(
//                              context: _context,
//                              builder: (BuildContext context) {
//                                return AlertDialog(
//                                  title: AlMajlisTextViewBold(
//                                    "Choose Payment Gateway.",
//                                    color: Colors.black,
//                                    size: 16,
//                                  ),
//                                  actions: <Widget>[
//                                    new FlatButton(
//                                      onPressed: () {
//                                        subscribeToPro();
//                                        Navigator.of(context).pop();
//                                      },
//                                      child: new Text("Pay online "),
//                                      color: Colors.teal,
//                                    ),
//                                    new FlatButton(
//                                      onPressed: () {
//                                        openInAppPurchases();
//                                        Navigator.of(context).pop();
//                                      },
//                                      child: new Text(
//                                          "Pay using In App Purchases for only iOS."),
//                                      color: Colors.teal,
//                                    ),
//                                  ],
//                                );
//                              });
                          } else {
                            subscribeToPro();
                          }
                        } else {
                          bookMeeting();
                        }
                      },
                      icon: AlMajlisImageIcons(
                        "drawables/lock-01.png",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AlMajlisBackButton(
            onClick: () {
              print("8...");
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: AlMajlisTextViewBold(
          "PAYMENT SUMMARY",
        ),
      ),
    );
  }

  void bookMeeting() async {
    core.startLoading(_context);
    ResponsePaymentSuccess response;
    try {
      response = await core.bookMeeting(
          widget.booking.userId, widget.booking.bookingDate);
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
                    subscribeToPro();
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
        //        flutterWebviewPlugin.launch(
        //          response.payload,
        //          hidden: true,
        //        );

        if (widget.charges == 0 && response.payload == null) {
          Navigator.pop(context, true);
        } else {
          var data = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ActivityPaymentView(response.payload),
            ),
          );
          Navigator.pop(context, null != data ? data : false);
        }
//        var data = await Navigator.of(context).push(MaterialPageRoute(
//            builder: (context) => ActivityPaymentView(response.payload)));
//        print("9...");
//        Navigator.pop(context, null != data ? data : false);
        //        Navigator.pop(context, true);
      } else {
        print("10...");
        Navigator.pop(context, false);
      }
    } else {
      print("11...");
      Navigator.pop(context, false);
    }
  }

  void _makeProUser(PurchaseDetails purchaseDetails) async {
    core.startLoading(_context);
    ResponseOk response;
    AlmajlisPurchesProUserRequest requestProUser =
        AlmajlisPurchesProUserRequest()
          ..productID = purchaseDetails.productID
          ..purchaseID = purchaseDetails.purchaseID
          ..transactionDate = purchaseDetails.transactionDate;

    try {
      response = await core.proUser(requestProUser);
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
                    // subscribeToPro();
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
        print("0.5.SUCESSFULL bought subscription");
        await Future.delayed(Duration(seconds: 0), () async {
          print("----Called from future");
          Navigator.pop(context, true);
        });

        // showDialog(
        //     context: _context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: AlMajlisTextViewBold(
        //             "Your pro purchase is successful, please go back to profile page and fill in Majlis details."),
        //         actions: <Widget>[
        //           new FlatButton(
        //             onPressed: () {
        //               Navigator.pop(context, true);
        //             },
        //             child: new Text("Ok"),
        //             color: Colors.teal,
        //           ),
        //         ],
        //       );
        //     });
        //        flutterWebviewPlugin.launch(
        //          response.payload,
        //          hidden: true,
        //        );
        // var data = await Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ActivityPaymentView(response.payload)));
        // Navigator.pop(context, null != data ? data : false);
        //        Navigator.pop(context, true);
      } else {
        print("2. SUCESSFULL bought subscription");
        Navigator.pop(context, false);
      }
    } else {
      print("3. SUCESSFULL bought subscription");
      Navigator.pop(context, false);
    }
  }

  void subscribeToPro() async {
    core.startLoading(_context);
    ResponsePaymentSuccess response;
    try {
      response = await core.goPro();
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
                    subscribeToPro();
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
        var data = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityPaymentView(response.payload),
          ),
        );

        if (null != data) {
          if (data) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ActivityPro(),
              ),
            );
            print("1...");
            Navigator.pop(context, true);
          } else {
            print("2...");
            Navigator.pop(context, false);
          }
        } else {
          print("3...");
          Navigator.pop(context, false);
        }
      } else {
        print("4...");
        Navigator.pop(context, false);
      }
    } else {
      print("5...");
      Navigator.pop(context, false);
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }

  void openInAppPurchases() {
    Map<String, PurchaseDetails> purchases = Map.fromEntries(
      _purchases.map(
        (PurchaseDetails purchase) {
          if (purchase.pendingCompletePurchase) {
            InAppPurchaseConnection.instance.completePurchase(purchase);
          }
          return MapEntry<String, PurchaseDetails>(
              purchase.productID, purchase);
        },
      ),
    );

    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first,
        applicationUserName: null,
        sandboxTesting: false);
    if (_products.first.id == _kConsumableId) {
      _connection.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: kAutoConsume || Platform.isIOS);
    } else {
      _connection.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    print("Start Loading");
    core.startLoading(_context);
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(Platform.isIOS
            ? _kiOSProductIds.toSet()
            : null); //_kAndroidProductIds.toSet()); //_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      core.stopLoading(_context);
      print("Stop Loading");
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        core.stopLoading(_context);
        print("Stop Loading");
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      core.stopLoading(_context);
      print("Stop Loading");
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<void> consume(String id) async {
    print('consume id is $id');
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    print('3. _listenToPurchaseUpdated');
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    print('deliverProduct'); // Last
    print(purchaseDetails);
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      // setState(() {
      _purchasePending = false;
      _consumables = consumables;
      // });
    } else {
      // setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
      // });
    }
    _makeProUser(purchaseDetails);
  }

  void handleError(IAPError error) {
    print('5. _listenToPurchaseUpdated');
    // core.stopLoading(_context);
    // setState(() {
    //   _purchasePending = false;
    // });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    print('7. _listenToPurchaseUpdated');
    print('_verifyPurchase');
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    print('_handleInvalidPurchase');
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlMajlisTextViewBold("Purchase failed"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Ok"),
                color: Colors.teal,
              ),
            ],
          );
        });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print('_listenToPurchaseUpdated');
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      // await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
      print('1. _listenToPurchaseUpdated');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        core.startLoading(_context);
        print('2. _listenToPurchaseUpdated');
//        showPendingUI();
      } else {
        print('4. _listenToPurchaseUpdated');
        core.stopLoading(_context);
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print('6. _listenToPurchaseUpdated');
//          core.stopLoading(_context);
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            print('8. _listenToPurchaseUpdated');
            deliverProduct(purchaseDetails);
          } else {
            print('9. _listenToPurchaseUpdated');
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          print('10. _listenToPurchaseUpdated');
          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print('11. _listenToPurchaseUpdated');
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }
//In app end
}
