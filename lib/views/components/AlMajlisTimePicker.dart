import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'dart:io' show Platform;

class AlMajlisTimePicker extends StatefulWidget {
  TextEditingController controller;
  String label;
  int initialTime;
  var onTimeChanged;
  var suffixIcon;
  AlMajlisTimePicker(this.label, this.onTimeChanged,
      {this.controller, this.initialTime, this.suffixIcon});
  @override
  _AlMajlisTimePickerState createState() => _AlMajlisTimePickerState();
}

class _AlMajlisTimePickerState extends State<AlMajlisTimePicker> {
  BuildContext _context;
  TimeOfDay intial;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (null != widget.initialTime && widget.initialTime > 0) {
      int minutes = (widget.initialTime / 60).round();
      int hours = (minutes / 60).round();
      minutes = minutes % 60;
      intial = TimeOfDay(hour: hours, minute: minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: () {
        _showTimePicker(intial);
      },
      child: Stack(
        children: <Widget>[
          AlMajlisTextField(
            widget.label,
            widget.controller,
            suffixIcon: widget.suffixIcon,
          ),
          Container(
            height: 40.0,
            width: double.maxFinite,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }

  void _showTimePicker(initial) {
    print(initial);
    final dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      intial == null ? 0 : intial.hour,
      intial == null ? 0 : intial.minute,
    );
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
                color: Colors.black,
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: TimePickerWidget(
                  initDateTime: intial == null ? DateTime.now() : dateTime,
                  dateFormat: 'HH:mm:s',
                  minuteDivider: 15,
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Colors.black,
                    cancelTextStyle: TextStyle(color: Colors.white),
                    confirmTextStyle: TextStyle(color: Colors.white),
                    itemTextStyle: TextStyle(color: Colors.white),
                    // pickerHeight: 300.0,
                    titleHeight: 24.0,
                    itemHeight: 30.0,
                  ),
                  onConfirm: (dateTime, selectedIndex) {
                    print(dateTime);
                    final timeOfDay =
                        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                    onTimeChange(timeOfDay);
                  },
                ));
          });
    } else {
      showTimePicker(
        context: _context,
        initialTime: intial == null ? TimeOfDay.now() : intial,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF000000),
              accentColor: const Color(0xFF000000),
              colorScheme: ColorScheme.light(primary: const Color(0xFF000000)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
      ).then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        onTimeChange(value);
      });
    }
  }

  void onTimeChange(value) {
    setState(() {
      if (value != null) {
        String timeMeridian = value.hour > 12 ? " PM" : " AM";
        String hour = value.hour > 12
            ? (value.hour - 12).toString()
            : value.hour.toString();
        if (int.parse(hour) < 10) {
          hour = "0" + hour;
        }
        String minutes = value.minute.toString();
        if (int.parse(minutes) < 10) {
          minutes = "0" + value.minute.toString();
        }
        widget.controller.text = hour + ":" + minutes + timeMeridian;
        widget.onTimeChanged(value);
      }
    });
  }
}
