import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AlMajlisLinkText extends StatelessWidget {
  String text;
  var size;
  var color;
  AlMajlisLinkText(this.text,{
    Key key, this.size = 12, this.color = Colors.teal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'ProximaNovaSemiBold',
            fontSize: size*1.0,
            color: color,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline
        ),
      ),
      onTap: _launchURL,
    );
  }

  _launchURL() async {
    if (await canLaunch(text)) {
      await launch(text);
    } else {
      Fluttertoast.showToast(msg: "Could not launch $text",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }
}