import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/ActivityNotification.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/activities/ActivitySplashScreen.dart';
import 'package:almajlis/core/core.dart';
import 'package:almajlis/ios_in_app_purchase/consumable_store.dart';
import 'package:almajlis/services/NavigationService.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
//  NavigationService navigationService = NavigationService();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ActivityStateBase<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    Core().getIt.registerLazySingleton(() => NavigationService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlMajlis',
      theme: ThemeData(
        hintColor: Colors.grey,
        primarySwatch: Colors.grey,
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0.5)),
      ),
      home: ActivitySplashScreen(),
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      navigatorKey: Core().getIt<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case 'navigation':
            return MaterialPageRoute(
                builder: (context) => ActivityNotificaton());
          default:
            return null;
        }
      },
    );
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase/store_kit_wrappers.dart';

// void main() {
//   // For play billing library 2.0 on Android, it is mandatory to call
//   // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
//   // as part of initializing the app.
//   InAppPurchaseConnection.enablePendingPurchases();
//   runApp(MyApp());
// }

// // Original code link: https://github.com/flutter/plugins/blob/master/packages/in_app_purchase/example/lib/main.dart

// const bool kAutoConsume = true;

// const String _kConsumableId = '';
// const String _kSubscriptionId = 'prosubscription';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   'prosubscription',
//   _kSubscriptionId
// ];

// // TODO: Please Add your android product ID here
// const List<String> _kAndroidProductIds = <String>[''];
// //Example
// //const List<String> _kAndroidProductIds = <String>[
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_1',
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_2',
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_3'
// //];

// // TODO: Please Add your iOS product ID here
// const List<String> _kiOSProductIds = <String>['prosubscription'];
// //Example
// //const List<String> _kiOSProductIds = <String>[
// //  'ADD_YOUR_IOS_PRODUCT_ID_1',
// //  'ADD_YOUR_IOS_PRODUCT_ID_2',
// //  'ADD_YOUR_IOS_PRODUCT_ID_3'
// //];

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String _queryProductError;

//   @override
//   void initState() {
//     DateTime currentDate = DateTime.now();
//     DateTime noADDate;

//     var fiftyDaysFromNow = currentDate.add(new Duration(days: 50));
//     print(
//         '${fiftyDaysFromNow.month} - ${fiftyDaysFromNow.day} - ${fiftyDaysFromNow.year} ${fiftyDaysFromNow.hour}:${fiftyDaysFromNow.minute}');

//     Stream purchaseUpdated =
//         InAppPurchaseConnection.instance.purchaseUpdatedStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//     });
//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _connection.isAvailable();

//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     ProductDetailsResponse productDetailResponse =
//         await _connection.queryProductDetails(Platform.isIOS
//             ? _kiOSProductIds.toSet()
//             : _kAndroidProductIds.toSet()); //_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();
//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }
//     final List<PurchaseDetails> verifiedPurchases = [];
//     for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//       if (await _verifyPurchase(purchase)) {
//         verifiedPurchases.add(purchase);
//       }
//     }
//     List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stack = [];
//     if (_queryProductError == null) {
//       stack.add(
//         ListView(
//           children: [
//             _buildConnectionCheckTile(),
//             _buildProductList(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//         Stack(
//           children: [
//             Opacity(
//               opacity: 0.3,
//               child: const ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('IAP Example'),
//         ),
//         body: Stack(
//           children: stack,
//         ),
//       ),
//     );
//   }

//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return Card(child: ListTile(title: const Text('Trying to connect...')));
//     }
//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.check : Icons.block,
//           color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
//       title: Text(
//           'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
//     );
//     final List<Widget> children = <Widget>[storeHeader];

//     if (!_isAvailable) {
//       children.addAll([
//         Divider(),
//         ListTile(
//           title: Text('Not connected',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle: const Text(
//               'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//         ),
//       ]);
//     }
//     return Card(child: Column(children: children));
//   }

//   Card _buildProductList() {
//     if (_loading) {
//       return Card(
//           child: (ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching products...'))));
//     }
//     if (!_isAvailable) {
//       return Card();
//     }
//     final ListTile productHeader = ListTile(title: Text('Products for Sale'));
//     List<ListTile> productList = <ListTile>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(ListTile(
//           title: Text('[${_notFoundIds.join(", ")}] not found',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle: Text(
//               'This app needs special configuration to run. Please see example/README.md for instructions.')));
//     }

//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verity the purchase data.
//     Map<String, PurchaseDetails> purchases =
//         Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         InAppPurchaseConnection.instance.completePurchase(purchase);
//       }
//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));
//     productList.addAll(_products.map(
//       (ProductDetails productDetails) {
//         PurchaseDetails previousPurchase = purchases[productDetails.id];
//         return ListTile(
//             title: Text(
//               productDetails.title,
//             ),
//             subtitle: Text(
//               productDetails.description,
//             ),
//             trailing: previousPurchase != null
//                 ? Icon(Icons.check)
//                 : FlatButton(
//                     child: Text(productDetails.price),
//                     color: Colors.green[800],
//                     textColor: Colors.white,
//                     onPressed: () {
//                       PurchaseParam purchaseParam = PurchaseParam(
//                           productDetails: productDetails,
//                           applicationUserName: null,
//                           sandboxTesting: false);
//                       if (productDetails.id == _kConsumableId) {
//                         _connection.buyConsumable(
//                             purchaseParam: purchaseParam,
//                             autoConsume: kAutoConsume || Platform.isIOS);
//                       } else {
//                         _connection.buyNonConsumable(
//                             purchaseParam: purchaseParam);
//                       }
//                     },
//                   ));
//       },
//     ));

//     return Card(
//         child:
//             Column(children: <Widget>[productHeader, Divider()] + productList));
//   }

//   Future<void> consume(String id) async {
//     print('consume id is $id');
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }

//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }

//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     print('deliverProduct'); // Last
//     // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID);
//       List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }

//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     print('_verifyPurchase');
//     return Future<bool>.value(true);
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//     print('_handleInvalidPurchase');
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     print('_listenToPurchaseUpdated');

//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       // await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
//       print('1. _listenToPurchaseUpdated');
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         print('2. _listenToPurchaseUpdated');
//         showPendingUI();
//       } else {
//         print('4. _listenToPurchaseUpdated');
//         // core.stopLoading(_context);

//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//           print('6. _listenToPurchaseUpdated');
//           // core.stopLoading(_context);
//           bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             print('8. _listenToPurchaseUpdated');
//             deliverProduct(purchaseDetails);
//           } else {
//             print('9. _listenToPurchaseUpdated');
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           print('10. _listenToPurchaseUpdated');
//           // core.stopLoading(_context);
//           if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//             await InAppPurchaseConnection.instance
//                 .consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           // core.stopLoading(_context);
//           print('11. _listenToPurchaseUpdated');
//           await InAppPurchaseConnection.instance
//               .completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }
// }
