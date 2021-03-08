import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlMajlisImageIcons.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewRegular.dart';
import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  final Color color;
  bool isFromProfile;
  RadioItem(this._item, this.color, {this.isFromProfile = false});
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(top: 5.0, bottom: 10.0, right: 5.0),
      child: new Row(
        children: <Widget>[
          Container(
              height: 15.0,
              width: 15.0,
              child: _item.isSelected
                  ? AlMajlisImageIcons(
                      "drawables/tick-01.png",
                      iconHeight: 10.0,
                    )
                  : new CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: CircleAvatar(
                            minRadius: 10.0, backgroundColor: color),
                      ),
                    )),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: _item.isSelected
                ? AlMajlisTextViewBold(
                    _item.text,
                    size: 16,
                    color: isFromProfile
                        ? Constants.COLOR_DARK_TEAL
                        : Colors.white,
                  )
                : AlMajlisTextViewRegular(
                    _item.text,
                    size: 16,
                  ),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
