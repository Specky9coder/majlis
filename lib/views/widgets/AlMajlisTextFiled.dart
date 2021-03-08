import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

class AlMajlisTextField extends StatelessWidget {

  String labelText;
  String errorText;
  var inputAction;
  var onSubmitted;
  var keyboardType;
  var suffixIcon;
  num maxLines;
  var onChanged;
  FocusNode focusNode;
  TextEditingController controller;
  var backgroundColor;
  AlMajlisTextField(this.labelText, this.controller,{
    Key key, this.errorText, this.inputAction, this.onSubmitted, this.keyboardType,
    this.suffixIcon, this.maxLines = 1, var this.onChanged, this.focusNode, this.backgroundColor = Colors.black
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
          fontFamily: 'ProximaNovaSemiBold',
          color: Colors.white
      ),
      textInputAction: inputAction,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      maxLines: maxLines,
      focusNode: focusNode,
      decoration: new InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(fontFamily: 'ProximaNovaMedium', color: Constants.COLOR_PRIMARY_GREY),
          errorText: null != errorText && !errorText.isEmpty ? errorText : null,
          errorStyle: TextStyle(color: Colors.red),
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              width: 5,
              color: Constants.COLOR_PRIMARY_GREY
            )
          ),
          filled: true,
          fillColor: backgroundColor
      ),
      onChanged: onChanged,
    );
  }
}