import 'package:almajlis/utils/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlMajlisProfileImageWithStatus extends StatelessWidget {
  num size;
  var status;
  var image;
  var color;
  bool isAssetImage;
  bool isFileImage;
  bool isOnline;
  bool isPro;
  AlMajlisProfileImageWithStatus(this.image, this.size,
      {Key key,
      this.status,
      this.color = Colors.white,
      this.isAssetImage = false,
      this.isFileImage = false,
      this.isOnline = false,
      this.isPro = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = size * 1.0;
    print(image.toString());
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: <Widget>[
          isFileImage
              ? CircleAvatar(
                  radius: size / 2,
                  backgroundColor:
                      isPro ? Constants.COLOR_PRIMARY_TEAL : Colors.white,
                  child: CircleAvatar(
                    radius: size / 2 - 2,
                    backgroundImage: isFileImage
                        ? FileImage(image)
                        : isAssetImage
                            ? AssetImage(image)
                            : NetworkImage(image),
                  ),
                )
              : Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                      color:
                          isPro ? Constants.COLOR_PRIMARY_TEAL : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isPro
                          ? [
                              BoxShadow(
                                color: isPro
                                    ? Constants.COLOR_PRIMARY_TEAL
                                    : Colors.white,
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : []),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, provider) {
                        return CircleAvatar(
                          radius: size / 2,
                          backgroundImage: provider,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container();
                      },
                      placeholder: (context, url) => Container(),

                    ),
                  ),
                ),
          Visibility(
            visible: isOnline,
            child: Container(
              height: 20,
              width: 20,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
            ),
          )
        ],
      ),
    );
  }
}
