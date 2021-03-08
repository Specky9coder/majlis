import 'package:almajlis/views/components/AlMajlisBackButton.dart';
import 'package:almajlis/views/components/AlMajlisBackground.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ActivityPhotoZoom extends StatelessWidget {
  String image;

  ActivityPhotoZoom(this.image);

  @override
  Widget build(BuildContext context) {
    return AlMajlisBackground(
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                AlMajlisBackButton(
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: PhotoView(
                imageProvider: NetworkImage(
                  image,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
