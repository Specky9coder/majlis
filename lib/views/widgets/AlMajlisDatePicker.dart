import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

import 'AlMajlisTextFiled.dart';
import 'dart:io' show Platform;

class AlMajlisDatePicker extends StatefulWidget {
  TextEditingController controller;
  String label;
  DateTime initialDate;
  var onDateChanged;
  var suffixIcon;
  String errorText;
  DateTime dateTime;
  DateTime endDate;
  DateTime startDate;
  AlMajlisDatePicker(this.label, this.onDateChanged,
      {this.controller,
      this.initialDate,
      this.suffixIcon,
      this.errorText,
      this.startDate,
      this.endDate});
  @override
  _AlMajlisDatePickerState createState() => _AlMajlisDatePickerState();
}

class _AlMajlisDatePickerState extends State<AlMajlisDatePicker> {
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: _showDatePicker,
      child: Stack(
        children: <Widget>[
          AlMajlisTextField(
            widget.label,
            widget.controller,
            suffixIcon: widget.suffixIcon,
            errorText: widget.errorText,
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

  void _showDatePicker({DateTime date}) {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              color: Colors.black,
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: DatePickerWidget(
                // minDateTime: DateTime.parse(MIN_DATETIME),
                // maxDateTime: DateTime.now(),
                initialDateTime: date == null ? DateTime.now() : date,
                dateFormat: "dd/MM/y",
                pickerTheme: DateTimePickerTheme(
                  backgroundColor: Colors.black,
                  cancelTextStyle: TextStyle(color: Colors.white),
                  confirmTextStyle: TextStyle(color: Colors.white),
                  itemTextStyle: TextStyle(color: Colors.white),
                  titleHeight: 24.0,
                  itemHeight: 30.0,
                ),
                onChange: (dateTime, selectedIndex) {
                  print(dateTime);
                },
                onConfirm: (dateTime, selectedIndex) {
                  if (dateTime != null) {
                    setState(() {
                      var dateFormat = DateFormat("dd/MM/y");
                      String date = dateFormat.format(dateTime);
                      widget.controller.text = date;
                      widget.onDateChanged(dateTime);
                    });
                  }
                },
              ),
            );
          });
    } else {
      showDatePicker(
        context: _context,
        initialDate: date == null ? DateTime.now() : date,
        firstDate:
            widget.startDate == null ? DateTime(1980, 1) : widget.startDate,
        lastDate: widget.endDate == null ? DateTime.now() : widget.endDate,
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
        setState(() {
          if (value != null) {
            var dateFormat = DateFormat("dd/MM/y");
            String date = dateFormat.format(value);
            widget.controller.text = date;
            widget.onDateChanged(value);
          }
        });
      });
    }
  }
}
