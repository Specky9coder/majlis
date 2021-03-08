import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlMajlisTextViewMedium extends StatelessWidget {

  String text;
  num size;
  var color;
  var weight;
  var icon;
  var iconSize;
  var align;
  int maxLines;
  AlMajlisTextViewMedium(this.text, {
    this.color = Colors.white, this.size = 12.0, this.weight = FontWeight.normal,
    this.icon, this.iconSize = 12, this.align = TextAlign.start, this.maxLines = 1
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'ProximaNovaMedium',
          fontSize: size*1.0,
          color: color,
          fontWeight: weight,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
