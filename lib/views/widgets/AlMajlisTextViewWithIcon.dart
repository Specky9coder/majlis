import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlMajlisTextViewMediumWithIcon extends StatelessWidget {

  String text;
  num size;
  var color;
  var weight;
  var icon;
  var iconSize;
  var align;
  AlMajlisTextViewMediumWithIcon(this.text, {
    this.color = Colors.white, this.size = 12.0, this.weight = FontWeight.normal,
    this.icon, this.iconSize = 12, this.align = TextAlign.start
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.asset(icon, height: iconSize*1.0,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'ProximaNovaMedium',
                fontSize: size*1.0,
                color: color,
                fontWeight: weight,
              ),
              textAlign: align,
            ),
          ),
        ),
      ],
    );
  }
}
