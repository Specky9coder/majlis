import 'package:flutter/material.dart';

class AlMajlisTextViewSemiBold extends StatelessWidget {

  String text;
  num size;
  var color;
  var weight;
  var icon;
  var iconSize;
  var align;
  AlMajlisTextViewSemiBold(this.text, {
    this.color = Colors.white, this.size = 12.0, this.weight = FontWeight.normal,
    this.icon, this.iconSize = 12, this.align = TextAlign.start
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'ProximaNovaSemiBold',
        fontSize: size*1.0,
        color: color,
        fontWeight: weight,
      ),
      textAlign: align,
    );
  }
}
