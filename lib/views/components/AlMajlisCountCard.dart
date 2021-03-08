import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';

class AlMajlisCountCard extends StatelessWidget {
  String icon;
  String label;
  String count;
  var rightPadding;
  var leftPadding;
  var onTap;
  AlMajlisCountCard(this.icon, this.label, this.count,{
    Key key, this.rightPadding =0 , this.leftPadding=0, this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right:rightPadding*1.0, left: leftPadding*1.0),
        child: GestureDetector(
          onTap: () {
            if(null != onTap)
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0) //         <--- border radius here
              ),
              color: Constants.COLOR_DARK_GREY,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        icon,
                        height: 20,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: Row(
                      children: <Widget>[
                        AlMajlisTextViewBold(
                          label,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      children: <Widget>[
                        AlMajlisTextViewMedium(
                          count,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}