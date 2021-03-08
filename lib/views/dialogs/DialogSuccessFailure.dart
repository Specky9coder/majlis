import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';

class DialogSuccessFailure extends StatefulWidget {

  String message;
  DialogSuccessFailure(this.message);
  @override
  _DialogSuccessFailureState createState() => _DialogSuccessFailureState();
}

class _DialogSuccessFailureState extends ActivityStateBase<DialogSuccessFailure> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(
                  15
              )
          )
      ),
      contentPadding: EdgeInsets.all(16),
      content: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top:16.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: AlMajlisTextViewBold(
                                widget.message,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: new Text("Ok"),
          color: Colors.teal,
        ),
      ],
    );
  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}
