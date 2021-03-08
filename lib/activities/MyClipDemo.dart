import 'package:almajlis/activities/MyCustomClipper.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

class MyClipDemo extends StatefulWidget {
  @override
  _CustomClipperState createState() => _CustomClipperState();
}

class _CustomClipperState extends State<MyClipDemo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ClipPath(
          child: Container(
            width: 50,
            height: 50,
            color: Constants.COLOR_PRIMARY_GREY,
          ),
          clipper: MyCustomClipper(),
        ),
      ),
    );
  }
}

