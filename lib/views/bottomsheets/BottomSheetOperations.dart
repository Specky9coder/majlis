import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';

class BottomSheetOperations extends StatelessWidget {
  var edit;
  var delete;
  int index;
  BottomSheetOperations(this.edit, this.delete, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0) //         <--- border radius here
                    ),
                    color: Constants.COLOR_DARK_GREY,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          edit(index);
                        },
                        child: AlMajlisTextViewMedium(
                          "Edit",
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          delete(index);
                        },
                        child: AlMajlisTextViewMedium(
                          "Delete",
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0) //         <--- border radius here
                      ),
                      color: Constants.COLOR_DARK_GREY,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: AlMajlisTextViewMedium(
                            "Cancel",
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
