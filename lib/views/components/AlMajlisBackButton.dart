import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:flutter/material.dart';

class AlMajlisBackButton extends StatelessWidget {
  var onClick;
  AlMajlisBackButton({Key key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Constants.COLOR_DARK_GREY),
        child: AlMajlisImageIcons(
          "drawables/back_arrow.png",
          iconHeight: 24,
        ),
      ),
      onTap: () {
        if (null != onClick) {
          onClick();
        }
      },
    );
  }
}
