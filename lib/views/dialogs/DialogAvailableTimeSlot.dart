import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';

class DialogAvailableTimeSlot extends StatefulWidget {
  List<DateTime> availableSlots = new List();
  int duration;
  String timeZoneName;

  DialogAvailableTimeSlot(this.availableSlots, this.duration, this.timeZoneName);
  @override
  _DialogAvailableTimeSlotState createState() =>
      _DialogAvailableTimeSlotState();
}

class _DialogAvailableTimeSlotState
    extends ActivityStateBase<DialogAvailableTimeSlot> {
  int selectedTimeSlot = -1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: EdgeInsets.all(16),
      content: Container(
        width: 300,
        height: 200,
        child: Column(
          children: [
            AlMajlisTextViewBold(
              null != widget.timeZoneName && widget.timeZoneName.isNotEmpty
                  ? widget.timeZoneName
                  : "",
              color: Colors.teal,
              align: TextAlign.center,
              maxLines: 2,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableSlots.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  String fromTime;
                  String toTime;
                  String timeMeridian =
                      widget.availableSlots.elementAt(index).hour >= 12
                          ? " PM"
                          : " AM";
                  String hour = widget.availableSlots.elementAt(index).hour > 12
                      ? (widget.availableSlots.elementAt(index).hour - 12)
                          .toString()
                      : widget.availableSlots.elementAt(index).hour.toString();
                  if (int.parse(hour) < 10) {
                    hour = "0" + hour;
                  }
                  if (widget.availableSlots.elementAt(index).minute < 10) {
                    fromTime = hour + ":0";
                  } else {
                    fromTime = hour + ":";
                  }
                  fromTime = fromTime +
                      widget.availableSlots.elementAt(index).minute.toString() +
                      timeMeridian;

                  timeMeridian = widget.availableSlots
                              .elementAt(index)
                              .add(Duration(minutes: widget.duration))
                              .hour >=
                          12
                      ? " PM"
                      : " AM";
                  hour = widget.availableSlots
                              .elementAt(index)
                              .add(Duration(minutes: widget.duration))
                              .hour >
                          12
                      ? (widget.availableSlots
                                  .elementAt(index)
                                  .add(Duration(minutes: widget.duration))
                                  .hour -
                              12)
                          .toString()
                      : widget.availableSlots
                          .elementAt(index)
                          .add(Duration(minutes: widget.duration))
                          .hour
                          .toString();
                  if (int.parse(hour) < 10) {
                    hour = "0" + hour;
                  }
                  if (widget.availableSlots
                          .elementAt(index)
                          .add(Duration(minutes: widget.duration))
                          .minute <
                      10) {
                    toTime = hour + ":0";
                  } else {
                    toTime = hour + ":";
                  }

                  toTime = toTime +
                      widget.availableSlots
                          .elementAt(index)
                          .add(Duration(minutes: widget.duration))
                          .minute
                          .toString() +
                      timeMeridian;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeSlot = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                20.0) //         <--- border radius here
                            ),
                        color: selectedTimeSlot == index
                            ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                            : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AlMajlisTextViewBold(
                          fromTime + " - " + toTime,
                          color: Colors.teal,
                          size: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(selectedTimeSlot);
          },
          child: new Text("Done"),
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
