import 'package:almajlis/activities/ActivityBase.dart';
import 'package:almajlis/core/wrappers/AlMajlisCountries.dart';
import 'package:almajlis/views/components/AlMajlisCustomDropdown.dart';
import 'package:almajlis/core/constants/countryStateConstant.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';

class AlMajlisCountryStatePicker extends StatefulWidget {
  @override
  _AlMajlisCountryStatePickerState createState() => _AlMajlisCountryStatePickerState();
}

class _AlMajlisCountryStatePickerState extends ActivityStateBase<AlMajlisCountryStatePicker> {
  AlMajlisCountries countries;
  List<String> countryStrings = List();
  List<String> stateStrings = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countries = AlMajlisCountries.fromMap(countryState);
    for(int index= 0 ; index < countries.countries.length; index++) {
      countryStrings.add(countries.countries.elementAt(index).name);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AlMajlisCustomDropdown(
          days: countryStrings,
          onChange: onCountryChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Container(
            child: stateStrings.length > 0 ? AlMajlisCustomDropdown(
              days: stateStrings,
              onChange: onStateChanged,
            ) : AlMajlisTextViewMedium("Select Country First")
          ),
        )

      ],
    );
  }

  onCountryChanged(value) {
    stateStrings = List();
    for(int index=0; index < countries.countries.elementAt(value).states.length; index++) {
      stateStrings.add(countries.countries.elementAt(value).states.elementAt(index).name);
    }
    setState(() {

    });
  }

  onStateChanged(value) {

  }

  @override
  onWidgetInitialized() {
    // TODO: implement onWidgetInitialized
    return null;
  }
}
