import 'package:almajlis/views/widgets/AlMajlisTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlMajlisDateTimePicker extends StatefulWidget {

  TextEditingController controller;
  String label;
  var onDateTimeChanged;
  var suffixIcon;
  String errorText;
  AlMajlisDateTimePicker(this.label, this.onDateTimeChanged, {this.controller,this.suffixIcon, this.errorText,});
  @override
  _AlMajlisDateTimePickerState createState() => _AlMajlisDateTimePickerState();
}

class _AlMajlisDateTimePickerState extends State<AlMajlisDateTimePicker> {
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
            backgroundColor: Colors.transparent,
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
    showDatePicker(
      context: _context,
      initialDate: DateTime.now(),
      firstDate:  DateTime.now(),
      lastDate: DateTime(DateTime.now().year+1)
    ).then((value) {
        _showTimePicker(value);
    });
  }

  void _showTimePicker(DateTime date) {
    showTimePicker(
      context: _context,
      initialTime: TimeOfDay.now()
    ).then((value) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        if(value != null) {
          var dateFormat = DateFormat("dd/MM/y");
          String dateString = dateFormat.format(date);
          String timeMeridian = value.hour > 12 ? " PM" : " AM";
          String hour = value.hour > 12 ? (value.hour-12).toString() : value.hour.toString();
          if(int.parse(hour) < 10) {
            hour = "0" + hour;
          }
          String minutes = value.minute.toString();
          if(int.parse(minutes) < 10) {
            minutes = "0" + value.minute.toString();
          }
          widget.controller.text = dateString + " " + hour + ":" + minutes + timeMeridian;
          widget.onDateTimeChanged(new DateTime(date.year, date.month, date.day,value.hour, value.minute));
        }
      });
    });

  }
}
