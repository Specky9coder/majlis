import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';

class DialogReport extends StatefulWidget {

 int type;
  DialogReport(this.type);
  @override
  _DialogReportState createState() => _DialogReportState();
}

class _DialogReportState extends ActivityStateBase<DialogReport> {

  int selectedReason = -1;
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
      content: Container(
        width: 300,
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Constants.reportReasons.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedReason = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                      20.0) //         <--- border radius here
                  ),
                  color: selectedReason == index ? Constants.COLOR_PRIMARY_TEAL_OPACITY : Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AlMajlisTextViewBold(
                    Constants.reportReasons.elementAt(index),
                    color: Colors.teal,
                    size: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(selectedReason);
          },
          child: new Text("Report"),
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
