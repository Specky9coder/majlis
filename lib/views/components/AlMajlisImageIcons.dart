import 'package:flutter/material.dart';

class AlMajlisImageIcons extends StatelessWidget {
  String iconName;
  double iconHeight;
  AlMajlisImageIcons(this.iconName, {Key key, this.iconHeight = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        iconName,
        height: iconHeight,
      ),
    );
  }
}
