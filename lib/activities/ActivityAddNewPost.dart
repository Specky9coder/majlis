import 'dart:io';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:almajlis/core/wrappers/AlMajlisLocation.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

import 'ActivityBase.dart';

class ActivityAddNewPost extends StatefulWidget {
  var image;
  ActivityAddNewPost({Key key, this.image}) : super(key: key);

  @override
  _ActivityAddNewPostState createState() => _ActivityAddNewPostState();
}

class _ActivityAddNewPostState extends ActivityStateBase<ActivityAddNewPost> {
  TextEditingController statusComments = TextEditingController();
  LocationResult _pickedLocation;
  List<Placemark> placemark = new List();
  String displayText;
  var city, country;
  AlMajlisLocation location;

  File image;
  File _pickedImage;
  final picker = ImagePicker();
  bool isCameraClicked = false;
  bool isLocationPickerClicked = false;

  List<String> dropdownOptions = ["7 days", "15 days", "30 days"];
  OverlayEntry daysOverlay;

  bool hasVideo = false;
  bool hasImage = false;
  bool hasFirstName = false;
  bool hasLastName = false;
  bool hasBio = false;
  bool hasBirthdate = false;
  bool hasLink = false;
  bool hasOccupation = false;
  BuildContext _context;

  String imageUrl = "";
  String videoUrl = "";

  bool isPro = false;

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;

  String uploadImageUrl;

  BorderRadius _borderRadius;
  AnimationController _animationController;
  IconData iconDropDown = Icons.keyboard_arrow_down;

  String selectedDays;
  String dropDownString;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");

    setState(() {
      if (null != widget.image) {
        image = File(widget.image.path);
        _pickedImage = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
        child: Scaffold(
            key: scaffoldState,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              if (isMenuOpen) closeMenu();
                              Navigator.pop(context);
                            },
                            child: AlMajlisTextViewBold(
                              "CANCEL",
                              size: 16,
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          /*
                          Container(
                            color: Colors.black,
                            child: Center(
                              child: Container(
                                width: 100,
                                height: 50.0,
                                key: _key,
                                color: Colors.black,
                                child: IconButton(
                                  icon: Row(
                                    children: <Widget>[
                                      AlMajlisImageIcons(
                                        "drawables/timmer-01.png",
                                        iconHeight: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: (dropDownString != null)
                                            ? Text(
                                                dropDownString,
                                                style: TextStyle(
                                                    fontSize: 10, color: Colors.white),
                                              )
                                            : Text(
                                                "days",
                                                style: TextStyle(
                                                    fontSize: 12, color: Colors.white),
                                              ),
                                      ),
                                      Icon(
                                        iconDropDown,
                                        color: Constants.COLOR_DARK_TEAL,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    if (isMenuOpen) {
                                      closeMenu();
                                    } else {
                                      openMenu();
                                    }
                                    setState(() {
                                      iconDropDown = isMenuOpen
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          */
                          GestureDetector(
                            onTap: () {
                              print("in post");
                              if (null != image) {
                                getSignedUrls();
                              } else if (null != statusComments.text &&
                                  !statusComments.text.isEmpty) {
                                addPost("");
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Image and text both cannot be empty",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2);
                              }
                            },
                            child: Container(
                              height: 40.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  color: Constants.COLOR_DARK_TEAL,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: InkWell(
                                child: Center(
                                    child: AlMajlisTextViewBold(
                                  "POST",
                                  size: 16,
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: null != imageUrl && !imageUrl.isEmpty
                                      ? AlMajlisProfileImageWithStatus(
                                    imageUrl,
                                    70.0,
                                    isPro: isPro,
                                  )
                                      : Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isPro
                                            ? Constants.COLOR_PRIMARY_TEAL
                                            : Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(colors: [
                                              Colors.purple,
                                              Colors.teal
                                            ])),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, top: 8.0, bottom: 8.0, right: 8.0),
                                    child: TextField(
                                      controller: statusComments,
                                      autofocus: true,
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 5,
                                      decoration: new InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText:
                                          " Who are you looking for ? \n ( post will auto expire from the feed within 14 days )"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _pickedImage != null ? true : false,
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15.0, right: 10.0, top: 8.0),
                                padding: EdgeInsets.only(
                                    top: 2.0,
                                    bottom: 2.0,
                                    left: 2.0,
                                    right: 2.0),
                                height: 100.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.white)),
                                child: _pickedImage != null
                                    ? Image.file(
                                        _pickedImage,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Positioned(
                                  right: 6.0,
                                  top: 4.0,
                                  child: GestureDetector(
                                      onTap: () {
                                        print("clicked");
                                        setState(() {
                                          _pickedImage = null;
                                          isCameraClicked = false;
                                        });
                                      },
                                      child: AlMajlisImageIcons(
                                        "drawables/delete-01.png",
                                        iconHeight: 16,
                                      )))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              scaffoldState.currentState.showBottomSheet(
                                  (context) => PostMenuBottomSheet(
                                      getImageFromCamera, getImageFromGallary));
                              setState(() {
                                isCameraClicked = true;
                              });
                            },
                            child: buttonAddImageAddLocation(
                                "add_image-01", "Add image ", isCameraClicked),
                          ),
                          InkWell(
                            onTap: getLocation,
                            child: buttonAddLocation(
                                "Add_location",
                                null == displayText
                                    ? "Add Location"
                                    : displayText,
                                isLocationPickerClicked),
                          )
                        ],
                      ),
                    )
                    //))),
                  ],
                ),
              ),
            )));
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    daysOverlay.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
    setState(() {
      iconDropDown = Icons.keyboard_arrow_down;
    });
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    daysOverlay = _daysOverlayBuilder();
    Overlay.of(context).insert(daysOverlay);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _daysOverlayBuilder() {
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
                  width: 200,
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
                              onDaysChanged(index);
                              String s = dropdownOptions[index];
                              String result = s.substring(0, s.indexOf('a'));
                              dropDownString = result;
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
                                          height: 2,
                                          color: Colors.white,
                                        )
                                ],
                              ),
                            ));
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

  onDaysChanged(index) {
    setState(() {
      selectedDays = dropdownOptions[index];
    });
  }

  Stack buttonAddLocation(String iconName, String title, bool isClickOccure) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          height: 50.0,
          width: 150.0,
          decoration: BoxDecoration(
              color: Constants.COLOR_DARK_GREY,
              borderRadius: BorderRadius.circular(10.0),
              border: displayText == null
                  ? Border.all(color: Colors.black)
                  : Border.all(color: Colors.white)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                "drawables/$iconName.png",
                height: 20,
                color: Colors.white,
              ),
              AlMajlisTextViewBold(
                title,
                size: 14.0,
                color: Colors.white,
              )
            ],
          ),
        ),
        Visibility(
          visible: displayText == null ? false : true,
          child: Positioned(
              right: 0.0,
              top: 6.0,
              child: GestureDetector(
                  onTap: () {
                    print("clicked");
                    setState(() {
                      displayText = null;
                    });
                  },
                  child: AlMajlisImageIcons(
                    "drawables/delete-01.png",
                    iconHeight: 16,
                  ))),
        )
      ],
    );
  }

  Container buttonAddImageAddLocation(
      String iconName, String title, bool isClickOccure) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 50.0,
      width: 150.0,
      decoration: BoxDecoration(
        color: isClickOccure
            ? Constants.COLOR_PRIMARY_TEAL_OPACITY
            : Constants.COLOR_DARK_GREY,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            "drawables/$iconName.png",
            height: 20,
            color: isClickOccure ? Constants.COLOR_PRIMARY_TEAL : Colors.white,
          ),
          AlMajlisTextViewBold(
            title,
            size: 14.0,
            color: isClickOccure ? Constants.COLOR_PRIMARY_TEAL : Colors.white,
          )
        ],
      ),
    );
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile.path != null) {
      image = null;
      image = File(pickedFile.path);
      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      _pickedImage = image;
    });
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      image = null;
      image = File(pickedFile.path);
      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      _pickedImage = image;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
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
        setState(() {
          if (null != response.payload.thumbUrl) {
            imageUrl = response.payload.thumbUrl;
          }
          isPro = response.payload.isPro;
        });
      }
    }
    core.stopLoading(_context);
  }

  void getSignedUrls() async {
    core.startLoading(_context);
    if (null != image) {
      ResponseSignedUrl response;
      try {
        print("extension" + path.extension(path.basename(image.path)));
        response = await core.getSignedUrl(
            path.extension(path.basename(image.path)).substring(1));
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
          print(response.payload);
          uploadImage(response.payload);
        }
      }
      core.stopLoading(_context);
    } else {
      core.stopLoading(_context);
    }
  }

  void uploadImage(String url) async {
    var response;
    core.startLoading(_context);
    print("Setting token ${core.getToken()}");
    try {
      print("before await");
      response = await http.put(url, body: image.readAsBytesSync());
      core.stopLoading(_context);
      if (response.statusCode == 200) {
        var urlArray = url.split("?");
        print(urlArray.elementAt(0));
        addPost(urlArray.elementAt(0));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      core.stopLoading(_context);
      print('Exception occurs: $e');
    }
  }

  void addPost(String url) async {
    core.startLoading(_context);
    bool hasError = false;

    if (null == statusComments.text || statusComments.text.isEmpty) {
      hasError = true;
      print("error");
    }

    print(hasError);
    if (!hasError) {
      int expiry = 14;
      print(location);
      AlMajlisPost post = AlMajlisPost()
        ..expiresOn = DateTime.now().add(Duration(days: expiry))
        ..location = location;

      print(post);

      if (null != statusComments.text && !statusComments.text.isEmpty)
        post.text = statusComments.text;

      if (null != url && !url.isEmpty) post.file = url;

      ResponseOk response;
      try {
        print(post);
        response = await core.addPost(post);
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

      core.stopLoading(_context);
      if (!core.systemCanHandel(response)) {
        if (response.status.statusCode == 0) {
          Navigator.pop(context);
        }
      }
    } else {
      core.stopLoading(_context);
      Fluttertoast.showToast(
          msg: "Cannot upload a post without caption",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  getLocation() async {
    LocationResult result = await showLocationPicker(
      context,
      "AIzaSyD5ugQSLzi0tQzBt2XOumP9nseFdLxzDJ8",
      initialCenter: LatLng(31.1975844, 29.9598339),
      requiredGPS: true,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      resultCardAlignment: Alignment.bottomCenter,
    );
    setState(() {
      _pickedLocation = result;
      _getCityNCountry();
      print("Location Pick ::: $_pickedLocation");
    });
  }

  _getCityNCountry() {
    Geolocator()
        .placemarkFromCoordinates(
            _pickedLocation.latLng.latitude, _pickedLocation.latLng.longitude)
        .then((onValue) {
      placemark = onValue;
      setState(() {
        country = placemark.elementAt(0).country;
        city = placemark.elementAt(0).locality;
        displayText = city + "," + country;
      });
      location = AlMajlisLocation()
        ..country = placemark.elementAt(0).country
        ..city = placemark.elementAt(0).locality
        ..latitude = _pickedLocation.latLng.latitude
        ..longitude = _pickedLocation.latLng.longitude
        ..locationName = placemark.elementAt(0).name;

      print(location);
    });
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser();
  }
}