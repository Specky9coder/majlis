import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/components/AlmajlisProfileImageWithStatus.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewMedium.dart';
import 'package:flutter/material.dart';

class AlMajlisExperienceCard extends StatelessWidget {
  var image;
  var title;
  var institute;
  var duration;
  var showDelete;
  var deleteExperience;
  AlMajlisExperienceCard(this.image, this.title,this.institute, this.duration,{
    Key key, this.showDelete = false , this.deleteExperience
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(10.0) //         <--- border radius here
        ),
        color: Constants.COLOR_DARK_GREY,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            AlMajlisProfileImageWithStatus(
                image,
                50.0
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AlMajlisTextViewBold(
                            title,
                            size: 16,
                          ),
                        ),
                        Visibility(
                          visible: showDelete,
                          child: GestureDetector(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: deleteExperience,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AlMajlisTextViewMedium(
                            institute,
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AlMajlisTextViewMedium(
                            duration,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}