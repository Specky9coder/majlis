import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {

  @override

  Path getClip(Size size) {
    Path path1 = Path()
      ..lineTo(size.width/2, 0)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);
    return path1;
  }



  @override

  bool shouldReclip(CustomClipper oldClipper) {

    return false;

  }

}