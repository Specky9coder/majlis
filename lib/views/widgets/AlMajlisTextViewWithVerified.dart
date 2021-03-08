import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlMajlisTextViewWithVerified extends StatelessWidget {
  String text;
  num size;
  var color;
  bool isVerified;

  AlMajlisTextViewWithVerified(this.text,
      {this.color = Colors.white, this.size = 12.0, this.isVerified = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontFamily: 'ProximaNovaBold',
            fontSize: size * 1.0,
            color: color,
          ),
        ),
//        Visibility(
//          visible: isVerified,
//          child: Padding(
//            padding: const EdgeInsets.only(left: 8.0),
//            child: Icon(
//              Icons.done,
//              color: Colors.teal,
//              size: size * 1.0,
//            ),
//          ),
//        )
      ],
    );
  }
}
