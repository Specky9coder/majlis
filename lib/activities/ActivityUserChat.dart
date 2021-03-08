import 'dart:io';

import 'package:almajlis/activities/ActivityBase.dart';

import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponseUser.dart';
import 'package:almajlis/core/wrappers/User.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisBackButton.dart';

import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Messages {
  String id;
  String sender_id;
  String sender_name;
  String text;

  Messages({String id, String sender_id, String sender_name, String text}) {
    this.id = id;
    this.sender_id = sender_id;
    this.sender_name = sender_name;
    this.text = text;
  }

  Messages.fromData(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.sender_id = snapshot.data["sender_id"];
    this.sender_name = snapshot.data["sender_name"];
    this.text = snapshot.data["text"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': sender_id,
      'sender_name': sender_name,
      'text': text,
    };
  }
}

class ChatRoom {
  final String id;

  ChatRoom({this.id});

  ChatRoom.fromData(Map<String, dynamic> data) : id = data['id'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class ActivityUserChat extends StatefulWidget {
  String myUserId;
  String otherPersonUserId;

  ActivityUserChat({Key key, this.myUserId, this.otherPersonUserId})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ActivityStateBase<ActivityUserChat> {
  final _chatsInstance = Firestore.instance.collection("chats");
  final _usersInstance = Firestore.instance.collection("users");
  Stream chatRooms;
  String chatRoomId;
  BuildContext _context;
  User myself;
  User otherUser;
  TextEditingController messageEditingController = new TextEditingController();
  String thumbUrl = "";
  String name = "";
  String occupation = "";
  String country = "";
  bool isPro = false;
  String myName = "";
  FocusNode messageFocusNode = FocusNode();
  bool sendinginProcess = false;

  Widget chatMessages() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final listOfUsers = snapshot.data.documents.toList();
                  Messages message = Messages.fromData(listOfUsers[index]);

                  return MessageTile(
                    message: message.text,
                    sendByMe: myName == message.sender_name,
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    sendinginProcess = true;
    postMessage();
  }

  //We can also add sender id here.
  Future<void> postMessage() async {
    myName = "";
    if (null != myself.firstName) {
      myName = myself.firstName + " ";
    }
    if (null != myself.lastName) {
      myName += myself.lastName;
    }
    if (messageEditingController.text.length > 0) {
      Map<String, dynamic> userDataMap = {
        "sender_user_id": widget.myUserId,
        "sender_name": myName,
        "text": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      _chatsInstance
          .document(chatRoomId)
          .collection("messages")
          .add(userDataMap)
          .then((value) {
        messageEditingController.text = "";
        sendinginProcess = false;
//            FocusScope.of(context).requestFocus(FocusNode());
        newMessage();
        getUserInfogetChats();
      }).catchError((e) {
        print(e.toString());
      });

// Update Time for self document
      var user = await _usersInstance
          .where('myUserId', isEqualTo: widget.myUserId)
          .getDocuments();

      if (user.documents.length > 0) {
        var convoList = _usersInstance
            .document(user.documents.first.documentID)
            .collection("conversations");

        var receipentUser = await convoList
            .where('id', isEqualTo: widget.otherPersonUserId)
            .getDocuments();

        String otherUserName = "";
        if (null != otherUser.firstName) {
          otherUserName = otherUser.firstName + " ";
        }
        if (null != otherUser.lastName) {
          otherUserName += otherUser.lastName;
        }
        if (receipentUser.documents.length > 0) {
          _usersInstance
              .document(user.documents.first.documentID)
              .collection("conversations")
              .document(receipentUser.documents.first.documentID)
              .updateData({'time': DateTime.now().millisecondsSinceEpoch});
        } else {
          Map<String, dynamic> userMap = {
            "id": widget.otherPersonUserId,
            "thumb": otherUser.thumbUrl,
            "occupation": otherUser.occupation,
            "country": otherUser.country,
            'time': DateTime.now().millisecondsSinceEpoch,
            'name': otherUserName,
            'isPro': otherUser.isPro
          };
          convoList.add(userMap).catchError((e) {
            print(e.toString());
          });
        }
      }

//// Update Time for reciepent document
      user = await _usersInstance
          .where('myUserId', isEqualTo: widget.otherPersonUserId)
          .getDocuments();

      if (user.documents.length > 0) {
        var convoList = _usersInstance
            .document(user.documents.first.documentID)
            .collection("conversations");

        var receipentUser = await convoList
            .where('id', isEqualTo: widget.myUserId)
            .getDocuments();

        if (receipentUser.documents.length > 0) {
          _usersInstance
              .document(user.documents.first.documentID)
              .collection("conversations")
              .document(receipentUser.documents.first.documentID)
              .updateData({'time': DateTime.now().millisecondsSinceEpoch});
        } else {
          Map<String, dynamic> userMap = {
            "id": widget.myUserId,
            "thumb": myself.thumbUrl,
            "occupation": myself.occupation,
            "country": myself.country,
            'time': DateTime.now().millisecondsSinceEpoch,
            'name': myself.firstName + " " + myself.lastName,
            'isPro': myself.isPro
          };
          convoList.add(userMap).catchError((e) {
            print(e.toString());
          });
        }
      }
    }
  }

  Future getChats() async {
    //Checking if these two users have a chat room created.
    var userData = await _chatsInstance
        .where('userId1', isEqualTo: widget.otherPersonUserId)
        .where('userId2', isEqualTo: widget.myUserId)
        .getDocuments();
    if (userData.documents.length > 0) {
      print(userData.documents.first.documentID);
      chatRoomId = userData.documents.first.documentID;
      getUserInfogetChats();
    } else {
      var userData = await _chatsInstance
          .where('userId1', isEqualTo: widget.myUserId)
          .where('userId2', isEqualTo: widget.otherPersonUserId)
          .getDocuments();
      if (userData.documents.length > 0) {
        print(userData.documents.first.documentID);
        chatRoomId = userData.documents.first.documentID;
        getUserInfogetChats();
      } else {
        //Added new user data to chat room
        Map<String, String> userDataMap = {
          "userId1": widget.myUserId,
          "userId2": widget.otherPersonUserId,
        };
        addUserInfo(userDataMap);
      }
    }
  }

  Future<void> addUserInfo(userData) async {
    _chatsInstance
        .add(userData)
        .then((value) => chatRoomId = value.documentID)
        .catchError((e) {
      print(e.toString());
    });

    var user = await _usersInstance
        .where('myUserId', isEqualTo: widget.myUserId)
        .getDocuments();

    if (user.documents.length <= 0) {
      Map<String, String> userMap = {
        "myUserId": widget.myUserId,
      };

      _usersInstance.add(userMap).catchError((e) {
        print(e.toString());
      });
    }

    user = await _usersInstance
        .where('myUserId', isEqualTo: widget.otherPersonUserId)
        .getDocuments();

    if (user.documents.length <= 0) {
      Map<String, String> userMap = {
        "myUserId": widget.otherPersonUserId,
      };

      _usersInstance.add(userMap).catchError((e) {
        print(e.toString());
      });
    }
  }

  getUserInfogetChats() async {
    final snaps = _chatsInstance
        .document(chatRoomId)
        .collection("messages")
        .orderBy('time')
        .snapshots();
    setState(() {
      chatRooms = snaps;
    });
  }

  @override
  void initState() {
    super.initState();
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AlMajlisBackButton(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      null != thumbUrl && !thumbUrl.isEmpty
                          ? AlMajlisProfileImageWithStatus(
                              thumbUrl,
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
                                padding: const EdgeInsets.all(4.0),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: AlMajlisTextViewBold(
                                      name,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: AlMajlisTextViewMedium(
                                      null != occupation ? occupation : "",
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: AlMajlisTextViewMedium(
                                      null != country ? country : "",
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                )
              ],
            ),
            Expanded(child: chatMessages()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (term) {
                          addMessage();
                        },
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!sendinginProcess) addMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUser(bool selfUser) async {
    core.startLoading(_context);
    ResponseUser response;
    User user;
    try {
      response = await core.getUser(
          id: selfUser ? widget.myUserId : widget.otherPersonUserId);
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
        user = response.payload;
        setState(() {
          if (selfUser) {
            myself = user;
            if (null != myself.firstName) myName = myself.firstName + " ";
            if (null != myself.lastName) myName += myself.lastName;
          } else {
            otherUser = user;
            if (null != otherUser.thumbUrl) thumbUrl = otherUser.thumbUrl;
            if (null != otherUser.firstName) name = otherUser.firstName + " ";
            if (null != otherUser.lastName) name += otherUser.lastName;
            if (null != otherUser.occupation) occupation = otherUser.occupation;
            if (null != otherUser.country) country = otherUser.country;
            if (null != otherUser.isPro) isPro = otherUser.isPro;
          }
        });
      }
    }
    core.stopLoading(_context);
  }

  void newMessage() async {
    ResponseOk response;
    User user;
    try {
      response = await core.newMessage(widget.otherPersonUserId);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Please Check Your Connectivity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    getUser(true);
    getUser(false);
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: sendByMe
              ? Constants.COLOR_PRIMARY_TEAL
              : Constants.COLOR_PRIMARY_TEAL_OPACITY,
        ),
        child: Linkify(
            text: message,
            onOpen: (link) async {
              print("onprint");
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                print('Could not launch $link');
              }
            },
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
