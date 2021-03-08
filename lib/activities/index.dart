// import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:almajlis/activities/ActivityBase.dart';
// import 'package:almajlis/activities/call.dart';
// import 'package:almajlis/core/wrappers/AlMajlisBooking.dart';
// import 'package:almajlis/core/wrappers/Booking.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class IndexPage extends StatefulWidget {
//   Booking booking;
//   IndexPage(this.booking);
//   @override
//   State<StatefulWidget> createState() => IndexState();
// }

// class IndexState extends ActivityStateBase<IndexPage> {
//   /// create a channelController to retrieve text value
//   final _channelController = TextEditingController();

//   /// if channel textField is validated to have error
//   bool _validateError = false;

//   ClientRole _role = ClientRole.Broadcaster;

//   @override
//   void dispose() {
//     // dispose input controller
//     _channelController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.booking);
//     _channelController.text = widget.booking.id;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           height: 400,
// //          child: Column(
// //            children: <Widget>[
// //              Row(
// //                children: <Widget>[
// //                  Expanded(
// //                      child: TextField(
// //                    controller: _channelController,
// //                    decoration: InputDecoration(
// //                      errorText:
// //                          _validateError ? 'Channel name is mandatory' : null,
// //                      border: UnderlineInputBorder(
// //                        borderSide: BorderSide(width: 1),
// //                      ),
// //                      hintText: 'Channel name',
// //                    ),
// //                  ))
// //                ],
// //              ),
// //              Column(
// //                children: [
// //                  ListTile(
// //                    title: Text(ClientRole.Broadcaster.toString()),
// //                    leading: Radio(
// //                      value: ClientRole.Broadcaster,
// //                      groupValue: _role,
// //                      onChanged: (ClientRole value) {
// //                        setState(() {
// //                          _role = value;
// //                        });
// //                      },
// //                    ),
// //                  ),
// //                  ListTile(
// //                    title: Text(ClientRole.Audience.toString()),
// //                    leading: Radio(
// //                      value: ClientRole.Audience,
// //                      groupValue: _role,
// //                      onChanged: (ClientRole value) {
// //                        setState(() {
// //                          _role = value;
// //                        });
// //                      },
// //                    ),
// //                  )
// //                ],
// //              ),
// //              Padding(
// //                padding: const EdgeInsets.symmetric(vertical: 20),
// //                child: Row(
// //                  children: <Widget>[
// //                    Expanded(
// //                      child: RaisedButton(
// //                        onPressed: onJoin,
// //                        child: Text('Join'),
// //                        color: Colors.blueAccent,
// //                        textColor: Colors.white,
// //                      ),
// //                    )
// //                  ],
// //                ),
// //              )
// //            ],
// //          ),
//         ),
//       ),
//     );
//   }

//   Future<void> onJoin() async {
//     // update input validation
//     setState(() {
//       _channelController.text.isEmpty
//           ? _validateError = true
//           : _validateError = false;
//     });
//     if (_channelController.text.isNotEmpty) {
//       // await for camera and mic permissions before pushing video page
//       await _handleCameraAndMic();
//       // push video page with given channel name
//       await Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallPage(
//             channelName: _channelController.text,
//             role: ClientRole.Broadcaster,
//             booking: widget.booking,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _handleCameraAndMic() async {
//     await PermissionHandler().requestPermissions(
//       [PermissionGroup.camera, PermissionGroup.microphone],
//     );
//   }

//   @override
//   onWidgetInitialized() {
//     // TODO: implement onWidgetInitialized
//     onJoin();
//   }
// }

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/activities/call.dart';
import 'package:almajlis/core/wrappers/AlMajlisBooking.dart';
import 'package:almajlis/core/wrappers/Booking.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  Booking booking;
  bool isInitiatedByMe;
  IndexPage(this.booking, {this.isInitiatedByMe = false});
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends ActivityStateBase<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.booking);
    _channelController.text = widget.booking.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
//          child: Column(
//            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Expanded(
//                      child: TextField(
//                    controller: _channelController,
//                    decoration: InputDecoration(
//                      errorText:
//                          _validateError ? 'Channel name is mandatory' : null,
//                      border: UnderlineInputBorder(
//                        borderSide: BorderSide(width: 1),
//                      ),
//                      hintText: 'Channel name',
//                    ),
//                  ))
//                ],
//              ),
//              Column(
//                children: [
//                  ListTile(
//                    title: Text(ClientRole.Broadcaster.toString()),
//                    leading: Radio(
//                      value: ClientRole.Broadcaster,
//                      groupValue: _role,
//                      onChanged: (ClientRole value) {
//                        setState(() {
//                          _role = value;
//                        });
//                      },
//                    ),
//                  ),
//                  ListTile(
//                    title: Text(ClientRole.Audience.toString()),
//                    leading: Radio(
//                      value: ClientRole.Audience,
//                      groupValue: _role,
//                      onChanged: (ClientRole value) {
//                        setState(() {
//                          _role = value;
//                        });
//                      },
//                    ),
//                  )
//                ],
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 20),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: RaisedButton(
//                        onPressed: onJoin,
//                        child: Text('Join'),
//                        color: Colors.blueAccent,
//                        textColor: Colors.white,
//                      ),
//                    )
//                  ],
//                ),
//              )
//            ],
//          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: ClientRole.Broadcaster,
            booking: widget.booking,
            isInitiated: widget.isInitiatedByMe,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    onJoin();
  }
}
