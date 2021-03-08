import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

class AlMajlisButton extends StatelessWidget {
  int style;
  String label;
  Widget icon;
  bool isFromProfile;
  var onClick;
  AlMajlisButton(this.label, this.style, this.onClick,
      {Key key, this.icon = null, this.isFromProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = Colors.white;
    var bgColor;
    var borderColor;
    switch (style) {
      case 0:
        bgColor = Colors.transparent;
        borderColor = Colors.white;
        break;
      case 1:
        bgColor = Constants.COLOR_PRIMARY_TEAL;
        borderColor = Constants.COLOR_PRIMARY_TEAL;
        break;
      case 2:
        bgColor = Constants.COLOR_PRIMARY_GREY;
        borderColor = Constants.COLOR_PRIMARY_GREY;
        break;
      case 3:
        textColor = Constants.COLOR_PRIMARY_TEAL;
        bgColor = Constants.COLOR_PRIMARY_TEAL_OPACITY;
        borderColor = Constants.COLOR_PRIMARY_TEAL_OPACITY;
        break;
      case 4:
        bgColor = isFromProfile
            ? Constants.COLOR_TRANSFERANT_GREY.withOpacity(0.87)
            : Constants.COLOR_PRIMARY_TRANS_GREY;
        borderColor = isFromProfile
            ? Constants.COLOR_TRANSFERANT_GREY.withOpacity(0.87)
            : Constants
                .COLOR_PRIMARY_TRANS_GREY; //Constants.COLOR_TRANSFERANT_GREY.withOpacity(0.89);
        break;
    }
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: borderColor),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) //         <--- border radius here
              ),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 8.0),
          child: null != label
              ? Row(
                  children: <Widget>[
                    null != icon ? icon : Container(),
                    Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                              fontFamily: 'ProximaNovaBold',
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: icon,
                ),
        ),
      ),
      onTap: onClick,
    );
  }
}
