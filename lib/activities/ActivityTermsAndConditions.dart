import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';

class ActivityTermsAndConditions extends StatefulWidget {
  ActivityTermsAndConditions({Key key}) : super(key: key);

  @override
  _ActivityTermsAndConditionsState createState() =>
      _ActivityTermsAndConditionsState();
}

class _ActivityTermsAndConditionsState
    extends State<ActivityTermsAndConditions> {
  String text =
      "1.1. Introduction \n 1.1.1.    Majlis is owned and operated by Majlis Holding W.L.L.. If you have any questions or comments about this privacy policy, please contact us at almajlisapplication@gmail.com \n By downloading or using Majlis, you agree to this Privacy Policy and our Terms of Service.\nIf you are under the age of 13, you may not download or use Majlis. We do not knowingly collect or maintain information from children under age 13 \.";
  @override
  Widget build(BuildContext context) {
    return AlMajlisBackground(
      Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Expanded(
              child: Text(
                "",
                style: TextStyle(
                  fontFamily: 'ProximaNovaBold',
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AlMajlisBackButton(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: AlMajlisTextViewBold(
          "Terms & Conditions_Privicy Policy",
          size: 16,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
    );
  }
}
