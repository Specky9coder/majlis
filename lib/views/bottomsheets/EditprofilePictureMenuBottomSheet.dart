import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';

class EditprofilePictureMenuBottomSheet extends StatelessWidget {
  var getImageFromCamera;
  var getImageFromGallary;
  var removeCurrentPhoto;
  EditprofilePictureMenuBottomSheet(this.getImageFromCamera,
      this.getImageFromGallary, this.removeCurrentPhoto);

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
                  height: 150,
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
                          getImageFromGallary();
                        },
                        child: AlMajlisTextViewMedium(
                          "Choose From Camera Roll",
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          getImageFromCamera();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: AlMajlisTextViewMedium(
                            "Take a Photo",
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          removeCurrentPhoto();
                        },
                        child: AlMajlisTextViewMedium(
                          "Remove Current Photo",
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
