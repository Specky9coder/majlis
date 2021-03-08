import 'package:flutter/material.dart';

class AlMajlisOtpTexField extends StatelessWidget {
  FocusNode focus;
  FocusNode nextFocus;
  TextEditingController textController;
  bool isLastDigit;
  var getOtpString;
  AlMajlisOtpTexField(this.textController, this.nextFocus,
      {Key key, this.focus, this.isLastDigit = false, this.getOtpString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 45,
          child: TextField(
              autocorrect: false,
              controller: textController,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'ProximaNovaSemiBold', color: Colors.white),
              textInputAction:
                  isLastDigit ? TextInputAction.next : TextInputAction.done,
              focusNode: focus,
              onChanged: (string) {
                if (string.length == 1)
                  FocusScope.of(context).requestFocus(nextFocus);
              },
              onSubmitted: (string) {
                if (isLastDigit) {
                  getOtpString();
                }
              },
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.black)),
        ),
      ),
    );
  }
}
