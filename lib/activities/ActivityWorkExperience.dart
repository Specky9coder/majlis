import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/PostMenuBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisDatePicker.dart';
import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class ActivityWorkExperience extends StatefulWidget {
  bool fromProfile;
  ActivityWorkExperience({this.fromProfile = false});
  @override
  _ActivityWorkExperienceState createState() => _ActivityWorkExperienceState();
}

class _ActivityWorkExperienceState
    extends ActivityStateBase<ActivityWorkExperience> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  bool toogleValue = false;
  var image;
  bool isFileImage = false;
  final picker = ImagePicker();
  User user;
  DateTime fromDate;
  DateTime toDate;
  BuildContext _context;
  String toDateErrorMessage;
  String fromDateErrorMessage;
  String imageUrl;
  final scaffoldState = GlobalKey<ScaffoldState>();
  File _pickedImage;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
        child: Scaffold(
      key: scaffoldState,
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
          "Work experience",
          size: 16,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (null != image) {
                    getSignedUrls();
                  } else {
                    editUser(imageUrl);
                  }
                },
                child: AlMajlisTextViewBold(
                  "UPDATE",
                  size: 12,
                  color: Constants.COLOR_PRIMARY_TEAL,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: <Widget>[
                            null != image
                                ? AlMajlisProfileImageWithStatus(
                                    image,
                                    100,
                                    isFileImage: isFileImage,
                                  )
                                : null != imageUrl && !imageUrl.isEmpty
                                    ? AlMajlisProfileImageWithStatus(
                                        imageUrl, 100)
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.purple,
                                                      Colors.teal
                                                    ])),
                                          ),
                                        ),
                                      ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.teal),
                                child: GestureDetector(
                                    onTap: () {
                                      scaffoldState.currentState
                                          .showBottomSheet((context) =>
                                              PostMenuBottomSheet(
                                                  getImageFromCamera,
                                                  getImageFromGallary));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: AlMajlisTextField(
                    "Company Name*",
                    companyNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: AlMajlisDatePicker(
                            "From",
                            onFromDateChnaged,
                            controller: fromDateController,
                            initialDate: fromDate,
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            errorText: fromDateErrorMessage,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: AlMajlisDatePicker(
                            "To",
                            onToDateChnaged,
                            controller: toDateController,
                            startDate: fromDate,
                            initialDate: toDate,
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            errorText: toDateErrorMessage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AlMajlisTextViewBold(
                        "This is my current job",
                        size: 16,
                      ),
                      Switch(
                        value: toogleValue,
                        onChanged: (value) {
                          setState(() {
                            toogleValue = value;
                            if (value) {
                              toDate = DateTime.now();
                              var dateFormat = DateFormat("dd/MM/y");
                              String date = dateFormat.format(toDate);
                              toDateController.text = date;
                            }
                          });
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Constants.COLOR_PRIMARY_GREY,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  onToDateChnaged(DateTime date) {
    setState(() {
      toDate = date;
    });
  }

  onFromDateChnaged(DateTime date) {
    setState(() {
      fromDate = date;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + "/temp.jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
    });
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
    });
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 20,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
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
        editUser(urlArray.elementAt(0));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      core.stopLoading(_context);
      print('Exception occurs: $e');
    }
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
        user = response.payload;
        setState(() {
          if (null != user.companyName && !user.companyName.isEmpty) {
            companyNameController.text = user.companyName;
          }
          if (null != user.workStart) {
            fromDate = user.workStart.add(DateTime.now().timeZoneOffset);
            var dateFormat = DateFormat("dd/MM/y");
            String date = dateFormat.format(fromDate);
            fromDateController.text = date;
          }
          if (null != user.workEnd) {
            toDate = user.workEnd.add(DateTime.now().timeZoneOffset);
            var dateFormat = DateFormat("dd/MM/y");
            String date = dateFormat.format(toDate);
            toDateController.text = date;
          }
          if (null != user.companyThumb) {
            imageUrl = user.companyThumb;
          }
          if (null != user.isCurrent) {
            toogleValue = user.isCurrent;
            if (user.isCurrent) {
              toDate = DateTime.now();
              var dateFormat = DateFormat("dd/MM/y");
              String date = dateFormat.format(toDate);
              toDateController.text = date;
            }
          }
        });
      }
    }
    core.stopLoading(_context);
  }

  void editUser(String url) async {
    bool hasError = false;

    if (!companyNameController.text.isEmpty) {
      if (!toogleValue) {
        if (null == toDate) {
          hasError = true;
          toDateErrorMessage = "To Date Cannot be null";
        }
      }
      if (null == fromDate) {
        hasError = true;
        fromDateErrorMessage = "From Date Cannot be null";
      }
    }

    if (null != fromDate && null != toDate) {
      if (fromDate.isAfter(toDate)) {
        if (null == toDate) {
          hasError = true;
          toDateErrorMessage = "To Date Cannot be before From Date";
        }
      }
    }

    if (hasError) {
      setState(() {});
    }
    else {
      if (companyNameController.text.isEmpty) {
        fromDate = null;
        toDate = null;
        toogleValue = false;
      } else {
        user
          ..companyName = companyNameController.text
          ..workStart = fromDate
          ..workEnd = toDate
          ..companyThumb = url
          ..isCurrent = toogleValue;

        print(user);
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
                        editUser(url);
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
            core.updateSession(core.getToken(), user);
            print("in success");
            if (widget.fromProfile) {
              print("in profile");
              Navigator.pop(context);
            }
          }
        }
      }
    }


  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return getUser();
  }
}
