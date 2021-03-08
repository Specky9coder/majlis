import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/bottomsheets/EditprofilePictureMenuBottomSheet.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisDatePicker.dart';
import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ActivityEditProfile extends StatefulWidget {
  bool fromProfile;
  ActivityEditProfile({this.fromProfile = false});
  @override
  _ActivityEditProfileState createState() => _ActivityEditProfileState();
}

class _ActivityEditProfileState extends ActivityStateBase<ActivityEditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  String firstNameErrorMessage;
  String lastNameErrorMessage;
  String bioErrorMessage;
  String linkErrorMessage;
  String birthdayErrorMessage;
  String countryErrorMessage;
  String cityErrorMessage;
  String occupationErrorMessage;
  String profileErrorMessage;
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode bioFocusNode = FocusNode();
  FocusNode linkFocusNode = FocusNode();
  DateTime birthdate;
  File image;
  File video;
  bool isFileImage = false;
  final picker = ImagePicker();
  User user;
  int progress = 0;
  var filePath = "";
  var thumbnailFile;
  var thumbNailUrl;
  String selectedOccupation;
  List<String> dropdownOptions = [
    "UI/UX Devloper",
    "Manufacturing",
    "Marketing",
    "Graphic Design"
  ];
  OverlayEntry occupationOverlay;

  bool hasVideo = false;
  bool hasOnlineVideo = false;
  bool hasImage = false;
  bool hasFirstName = false;
  bool hasLastName = false;
  bool hasCity = false;
  bool hasCountry = false;
  bool hasBio = false;
  bool hasBirthdate = false;
  bool hasLink = false;
  bool hasOccupation = false;
  bool hasProfilePicture = false;
  BuildContext _context;

  String imageUrl = "";
  String videoUrl = "";
  bool videoProgress = false;

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;

  BorderRadius _borderRadius;
  AnimationController _animationController;
  IconData iconDropDown = Icons.keyboard_arrow_down;

  final scaffoldState = GlobalKey<ScaffoldState>();

  String selectedValue;
  bool reload;

  @override
  void initState() {
    // TODO: implement initState
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
    if (null != imageUrl && !imageUrl.isEmpty) {
      print("image" + imageUrl);
      setState(() {
        hasProfilePicture = true;
      });
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AlMajlisTextViewBold(
                                    "Profile Completion",
                                    size: 12,
                                  ),
                                  AlMajlisTextViewBold(
                                    (progress * 10).toString() + "%",
                                    size: 12,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0) //         <--- border radius here
                                        ),
                                  ),
                                  child: GradientProgressIndicator(
                                    gradient: LinearGradient(
                                        colors: [Colors.purple, Colors.teal]),
                                    value: progress / 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              onTap: pickVideo,
                              child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0,
                                        color: Constants.COLOR_PRIMARY_GREY),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) //         <--- border radius here
                                        ),
                                    color: Colors.transparent,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      hasOnlineVideo
                                          ? Positioned(
                                              top: 0,
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: null !=
                                                                thumbNailUrl &&
                                                            !thumbNailUrl
                                                                .isEmpty
                                                        ? Image.network(
                                                            thumbNailUrl,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Center(
                                                            child:
                                                                AlMajlisTextViewBold(
                                                            path.basename(
                                                                "Unable To Load Thumbnail"),
                                                            size: 12,
                                                          )),
                                                  )),
                                            )
                                          : hasVideo
                                              ? Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        child: null !=
                                                                    filePath &&
                                                                !filePath
                                                                    .isEmpty
                                                            ? Image.file(
                                                                thumbnailFile,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Center(
                                                                child:
                                                                    AlMajlisTextViewBold(
                                                                path.basename(
                                                                    video.path),
                                                                size: 12,
                                                              )),
                                                      )),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child:
                                                            AlMajlisTextViewBold(
                                                          "ADD INTRO VIDEO",
                                                          size: 12,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                      Visibility(
                                        visible: hasOnlineVideo || hasVideo,
                                        child: Positioned(
                                          right: 10,
                                          top: 10,
                                          child: GestureDetector(
                                            onTap: deleteVideo,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: [
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
                                              : null != imageUrl &&
                                                      !imageUrl.isEmpty
                                                  ? AlMajlisProfileImageWithStatus(
                                                      imageUrl, 100)
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    Colors
                                                                        .purple,
                                                                    Colors.teal
                                                                  ])),
                                                        ),
                                                      ),
                                                    ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              child: Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.teal),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onTap: () {
                                                scaffoldState.currentState
                                                    .showBottomSheet((context) =>
                                                        EditprofilePictureMenuBottomSheet(
                                                            getImageFromCamera,
                                                            getImageFromGallary,
                                                            removeCurrentPhoto));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Visibility(
                                        visible: !hasProfilePicture,
                                        child: AlMajlisTextViewRegular(
                                          "Profile picture cannot \n be blank.",
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      children: <Widget>[
                                        AlMajlisTextField(
                                          "First Name",
                                          firstNameController,
                                          errorText: firstNameErrorMessage,
                                          onChanged: (String enteredString) {
                                            if (enteredString.length == 0 ||
                                                enteredString.isEmpty) {
                                              setState(() {
                                                hasFirstName = false;
                                                progress -= 1;
                                              });
                                            } else {
                                              if (!hasFirstName) {
                                                setState(() {
                                                  progress += 1;
                                                  hasFirstName = true;
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: AlMajlisTextField(
                                            "Last Name",
                                            lastNameController,
                                            errorText: lastNameErrorMessage,
                                            focusNode: lastNameFocusNode,
                                            onChanged: (String enteredString) {
                                              if (enteredString.length == 0 ||
                                                  enteredString.isEmpty) {
                                                setState(() {
                                                  hasLastName = false;
                                                  progress -= 1;
                                                });
                                              } else {
                                                if (!hasLastName) {
                                                  setState(() {
                                                    progress += 1;
                                                    hasLastName = true;
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
//                      Padding(
//                        padding: const EdgeInsets.only(top:16),
//                        child: Container(
//                          width: double.infinity,
//                          height: 50.0,
//                          key: _key,
//                          decoration: BoxDecoration(
//                            border: Border.all(
//                                width: 1.0,
//                                color: Constants.COLOR_PRIMARY_GREY
//                            ),
//                            borderRadius: BorderRadius.all(
//                                Radius.circular(10.0) //         <--- border radius here
//                            ),
//                            color: Colors.transparent,
//                          ),
//                          child: IconButton(
//                            icon: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Padding(
//                                  padding: const EdgeInsets.all(4.0),
//                                  child: AlMajlisTextViewBold(
//                                    null != selectedOccupation && !selectedOccupation.isEmpty ? selectedOccupation : "Occupation" ,
//                                    size: 16,
//                                  ),
//                                ),
//                                Icon(
//                                  iconDropDown,
//                                  size: 20,
//                                )
//                              ],
//                            ),
//                            color: Colors.white,
//                            onPressed: () {
//                              if (isMenuOpen) {
//                                closeMenu();
//                              } else {
//                                openMenu();
//                              }
//                              setState(() {
//                                iconDropDown = isMenuOpen
//                                    ? Icons.keyboard_arrow_up
//                                    : Icons.keyboard_arrow_down;
//                              });
//                            },
//                          ),
//                        )
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.only(top:16.0),
//                        child: AlMajlisCountryStatePicker(),
//                      ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AlMajlisTextField(
                                    "Occupation",
                                    occupationController,
                                    errorText: occupationErrorMessage,
                                    onChanged: (String enteredString) {
                                      if (enteredString.length == 0 ||
                                          enteredString.isEmpty) {
                                        setState(() {
                                          hasOccupation = false;
                                          progress -= 1;
                                        });
                                      } else {
                                        if (!hasOccupation) {
                                          setState(() {
                                            progress += 1;
                                            hasOccupation = true;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AlMajlisTextField(
                                    "City",
                                    cityController,
                                    errorText: cityErrorMessage,
                                    onChanged: (String enteredString) {
                                      if (enteredString.length == 0 ||
                                          enteredString.isEmpty) {
                                        setState(() {
                                          hasCity = false;
                                          progress -= 1;
                                        });
                                      } else {
                                        if (!hasCity) {
                                          setState(() {
                                            progress += 1;
                                            hasCity = true;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AlMajlisTextField(
                                    "Country",
                                    countryController,
                                    errorText: countryErrorMessage,
                                    onChanged: (String enteredString) {
                                      if (enteredString.length == 0 ||
                                          enteredString.isEmpty) {
                                        setState(() {
                                          hasCountry = false;
                                          progress -= 1;
                                        });
                                      } else {
                                        if (!hasCountry) {
                                          setState(() {
                                            progress += 1;
                                            hasCountry = true;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AlMajlisTextField("Bio", bioController,
                                      errorText: bioErrorMessage,
                                      focusNode: bioFocusNode,
                                      maxLines: 4,
                                      onChanged: (String enteredString) {
                                    if (enteredString.length == 0 ||
                                        enteredString.isEmpty) {
                                      setState(() {
                                        hasBio = false;
                                        progress -= 1;
                                      });
                                    } else {
                                      if (!hasBio) {
                                        setState(() {
                                          progress += 1;
                                          hasBio = true;
                                        });
                                      }
                                    }
                                  }),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AlMajlisTextField(
                                    "Link",
                                    linkController,
                                    focusNode: linkFocusNode,
                                    onChanged: (String enteredString) {
                                      if (enteredString.length == 0 ||
                                          enteredString.isEmpty) {
                                        setState(() {
                                          hasLink = false;
                                          progress -= 1;
                                        });
                                      } else {
                                        if (!hasLink) {
                                          setState(() {
                                            progress += 1;
                                            hasLink = true;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: AlMajlisDatePicker(
                              "Birthday",
                              onBirthDateChanged,
                              controller: birthdayController,
                              errorText: birthdayErrorMessage,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          leading: widget.fromProfile
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: AlMajlisBackButton(
                    onClick: () {
//              if(isMenuOpen)
//                closeMenu();
                      Navigator.pop(context);
                    },
                  ),
                )
              : Container(),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: AlMajlisTextViewBold(
            "Edit Profile",
            size: 16,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Center(
                  child: AlMajlisTextViewBold(
                    "UPDATE",
                    size: 12,
                    color: Constants.COLOR_PRIMARY_TEAL,
                  ),
                ),
                onTap: onUpdate,
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteVideo() {
    setState(() {
      user.videoUrl = null;
      hasVideo = false;
      hasOnlineVideo = false;
      video = null;
      videoUrl = "";
      progress -= 1;
      videoProgress = false;
    });
  }
//
//  findButton() {
//    RenderBox renderBox = _key.currentContext.findRenderObject();
//    buttonSize = renderBox.size;
//    buttonPosition = renderBox.localToGlobal(Offset.zero);
//  }
//
//  void closeMenu() {
//    occupationOverlay.remove();
//    _animationController.reverse();
//    isMenuOpen = !isMenuOpen;
//    setState(() {
//      iconDropDown = Icons.keyboard_arrow_down;
//    });
//  }
//
//  void openMenu() {
//    findButton();
//    _animationController.forward();
//    occupationOverlay = _occupationOverlayBuilder();
//    Overlay.of(context).insert(occupationOverlay);
//    isMenuOpen = !isMenuOpen;
//  }
//
//  OverlayEntry _occupationOverlayBuilder() {
//    return OverlayEntry(
//      builder: (context) {
//        return Positioned(
//          top: buttonPosition.dy + buttonSize.height,
//          left: buttonPosition.dx,
//          width: buttonSize.width,
//          child: Material(
//            color: Colors.transparent,
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  width: double.infinity,
//                  decoration: BoxDecoration(
//                    color: Color(0xFF434343), //widget.backgroundColor,
//                    borderRadius: _borderRadius,
//                  ),
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: List.generate(
//                      dropdownOptions.length,
//                          (index) {
//                        return GestureDetector(
//                            onTap: () {
//                              setState(() {
//                                selectedOccupation = dropdownOptions[index];
//                                if (!hasOccupation) {
//                                    progress += 1;
//                                    hasOccupation = true;
//                                }
//                              });
//                              closeMenu();
//                            },
//                            child: Container(
//                              margin: EdgeInsets.only(top: 4.0),
//                              child: Column(
//                                children: <Widget>[
//                                  Padding(
//                                    padding: const EdgeInsets.all(12.0),
//                                    child: Text(
//                                      dropdownOptions[index],
//                                      style: TextStyle(color: Colors.white),
//                                    ),
//                                  ),
//                                  index != dropdownOptions.length - 1 ? Divider(
//                                    height: 2,
//                                    color: Colors.white,
//                                  ) : Container()
//                                ],
//                              ),
//                            ));
//                      },
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }
//
//  onOccupationChanged(index) {
//
//      selectedOccupation = dropdownOptions[index];
//      if (!hasOccupation) {
//        setState(() {
//          progress += 1;
//          hasOccupation = true;
//        });
//      }
//  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + "/temp.jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
      if (!hasImage) {
        progress += 1;
        hasImage = true;
      }
    });
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
      if (!hasImage) {
        progress += 1;
        hasImage = true;
        hasProfilePicture = true;
      }
    });
  }

  Future getImageFromGallary() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      image = File(pickedFile.path);
      final dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      image = await testCompressAndGetFile(image, targetPath);
    }
    setState(() {
      isFileImage = true;
      if (!hasImage) {
        progress += 1;
        hasImage = true;
        hasProfilePicture = true;
      }
    });
  }

  Future removeCurrentPhoto() async {
    Navigator.pop(context);

    setState(() {
      isFileImage = false;
      image = null;
      imageUrl = null;
      user.thumbUrl = null;
      hasImage = false;
      progress -= 1;
      hasProfilePicture = false;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  }

  Future pickVideo() async {
    if (Platform.isAndroid) {
      File file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (null != file) {
        await genThumbnailFile(file);
        print(filePath);
        setState(() {
          video = File(file.path);
          print('videoPAth: ${video.path}');
          if (!videoProgress) {
            progress += 1;
            videoProgress = true;
          }
          hasVideo = true;
          hasOnlineVideo = false;
        });
      }
    } else if (Platform.isIOS) {
      File _video;
      File pickedVideo =
          await ImagePicker.pickVideo(source: ImageSource.gallery);
      _video = pickedVideo;
      setState(() {
        video = File(_video.path);
        print('videoPAth: ${video.path}');
        if (!videoProgress) {
          progress += 1;
          videoProgress = true;
        }
        hasVideo = true;
        hasOnlineVideo = false;
      });
    }
  }

  Future genThumbnailFile(video) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: video.path,
        thumbnailPath: (await getApplicationDocumentsDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 64,
        quality: 100);
    thumbnailFile = File(thumbnail);
    print(thumbnailFile.path);
    filePath = thumbnailFile.path;
  }

  Future genThumbnailFileOnline(video) async {
    print("in thumbnail" + video);
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: video,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 64,
        quality: 100);
    print("after thumbnail");
    final file = File(thumbnail);
    print("filepath " + file.path);

    setState(() {
      if (filePath == null) {
        filePath = "";
      } else {
        filePath = file.path;
      }
    });
  }

  onBirthDateChanged(DateTime date) {
    birthdate = date;
    // if (!hasBirthdate) {
    //   setState(() {
    //     progress += 1;
    //     hasBirthdate = true;
    //   });
    // }
  }

  onUpdate() {
    if (null != video && null != thumbnailFile) {
      getSignedUrls();
    } else {
      editUser(thumbNailUrl);
    }
  }

  void getSignedUrls() async {
    core.startLoading(_context);
    if (null != thumbnailFile) {
      ResponseSignedUrl response;
      try {
        print("extension" + path.extension(path.basename(thumbnailFile.path)));
        response = await core.getSignedUrl(
            path.extension(path.basename(thumbnailFile.path)).substring(1));
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
      response = await http.put(url, body: thumbnailFile.readAsBytesSync());
      core.stopLoading(_context);
      if (response.statusCode == 200) {
        var urlArray = url.split("?");
        print("actualUrl " + urlArray.elementAt(0));
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
          if (null != core.getCountryName() && !core.getCountryName().isEmpty) {
            countryController.text = core.getCountryName();
            progress += 1;
            hasCountry = true;
          }
          if (null != user.firstName && !user.firstName.isEmpty) {
            firstNameController.text = user.firstName;
            progress += 1;
            hasFirstName = true;
          }
          if (null != user.lastName && !user.lastName.isEmpty) {
            lastNameController.text = user.lastName;
            progress += 1;
            hasLastName = true;
          }
          if (null != user.bio && !user.bio.isEmpty) {
            bioController.text = user.bio;
            progress += 1;
            hasBio = true;
          }
          if (null != user.link && !user.link.isEmpty) {
            linkController.text = user.link;
            progress += 1;
            hasLink = true;
          }
          if (null != user.occupation && !user.occupation.isEmpty) {
            occupationController.text = user.occupation;
            progress += 1;
            hasOccupation = true;
          }
          if (null != user.country && !user.country.isEmpty) {
            if (countryController.text.isEmpty) {
              progress += 1;
            }
            countryController.text = user.country;
            core.setCountryName(countryController.text);
            hasCountry = true;
          }
          if (null != user.city && !user.city.isEmpty) {
            cityController.text = user.city;
            progress += 1;
            hasCity = true;
          }
          if (null != user.birthdate) {
            birthdate = user.birthdate.add(DateTime.now().timeZoneOffset);
            var dateFormat = DateFormat("dd/MM/y");
            String date = dateFormat.format(birthdate);
            birthdayController.text = date;
            print("getbirthdate" + user.birthdate.toString());
            // progress += 1;
            // hasBirthdate = true;
          }
          if (null != user.thumbUrl) {
            imageUrl = user.thumbUrl;
            hasProfilePicture = true;
            progress += 1;
          }
          if (null != user.videoUrl) {
            videoUrl = user.videoUrl;
            progress += 1;
            hasOnlineVideo = true;
            videoProgress = true;
            print("hasVideo");
            print(user.videoIntroThumb);
            if (null != user.videoIntroThumb) {
              thumbNailUrl = user.videoIntroThumb;
              // print("+++++++++++++++++++++++++++++++++++++" +
              //     user.videoIntroThumb);
            }
            genThumbnailFileOnline(user.videoUrl);
          }
          if (null != user.isPro && user.isPro) {
            progress += 1;
          }
        });
      }
    }
    core.stopLoading(_context);
  }

  void editUser(url) async {
    print("thumbnail in edit user");
    print(url);
    core.startLoading(_context);
    bool hasError = false;

    if (firstNameController.text.isEmpty) {
      hasError = true;
      firstNameErrorMessage = "First Name Cannot be blank";
    } else if (firstNameController.text.length > 10) {
      hasError = true;
      firstNameErrorMessage = "Name Can't be greater than 10";
    }
    if (lastNameController.text.isEmpty) {
      hasError = true;
      lastNameErrorMessage = "Last Name Cannot be blank";
    } else if (lastNameController.text.length > 10) {
      hasError = true;
      lastNameErrorMessage = "Name Can't be greater than 10";
    }
    if (bioController.text.length > 160) {
      print("Length --------->>> " + bioController.text.length.toString());
      hasError = true;
      bioErrorMessage = "Bio can't be greater than 160 letter";
    }
//    if (occupationController.text.isEmpty) {
//      hasError = true;
//      occupationErrorMessage = "Occupation Cannot be blank";
//    }
    if (image == null) {
      if (imageUrl == null || imageUrl.isEmpty) {
        hasError = true;
        hasProfilePicture = false;
      }
    }
//    if(null == imageUrl && imageUrl.isEmpty) {
//      if (image == null) {
//        hasError = true;
//        hasProfilePicture = false;
//      }
//      hasError = true;
//      hasProfilePicture = false;
//    }

    print(hasError);
    if (!hasError) {
      print("Thumbnail url +++++++++++++++++++++++++++++");
      // print(url);
      User requestUser = null != user ? user : User()
        ..firstName = firstNameController.text
        ..lastName = lastNameController.text
        ..occupation = occupationController.text
        ..bio = bioController.text
        ..link = linkController.text
        ..country = countryController.text
        ..city = cityController.text
        ..videoIntroThumb = url
        ..birthdate = birthdate;

      //print("video thumb url tracking" + requestUser.videoIntroThumb);
      print("birthdate" + requestUser.birthdate.toString());

      print(requestUser);
      ResponseOk response;
      try {
        response = await core.editUser(requestUser);
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
      if (!core.systemCanHandel(response)) {
        if (response.status.statusCode == 0) {
          if (null != image || null != video) {
            core.updateSession(core.getToken(), requestUser);
            editUserMedia();
          } else {
            core.stopLoading(_context);
            core.updateSession(core.getToken(), requestUser);
//            if(isMenuOpen)
//            closeMenu();
            Navigator.pop(context);
          }
        } else {
          core.stopLoading(_context);
        }
      } else {
        core.stopLoading(_context);
      }
    } else {
      core.stopLoading(_context);
      setState(() {});
    }
  }

  void editUserMedia() async {
    FormData formData;
    if (null != image) {
      if (null != video) {
        formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path,
              filename: path.basename(image.path)),
          "video": await MultipartFile.fromFile(video.path,
              filename: path.basename(video.path))
        });
      } else {
        formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path,
              filename: path.basename(image.path)),
        });
      }
    } else if (null != video) {
      formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(video.path,
            filename: path.basename(video.path))
      });
    }
    print("Setting token ${core.getToken()}");
    try {
      Response response = await Dio().post(
          Server.BASE_URL + "/api/users/me/media",
          data: formData,
          options:
              Options(headers: {"authorization": "Bearer " + core.getToken()}));
      core.stopLoading(_context);
    } catch (_) {
      core.stopLoading(_context);
      Fluttertoast.showToast(
          msg: "Server Error, Please Try Later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
//    if(isMenuOpen)
//      closeMenu();
    Navigator.pop(context);
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser();
    return null;
  }
}
