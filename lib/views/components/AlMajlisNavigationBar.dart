import 'package:almajlis/activities/ActivityDiscover.dart';
import 'package:almajlis/activities/ActivityNotification.dart';
import 'package:almajlis/activities/ActivityPosts.dart';
import 'package:almajlis/activities/ActivityProfile.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

class AlMajlisNavigationBar extends StatefulWidget {
  int selected;
  var refreshFunction;

  AlMajlisNavigationBar(
    this.selected,
    this.refreshFunction, {
    Key key,
  }) : super(key: key);

  @override
  _AlMajlisNavigationBarState createState() => _AlMajlisNavigationBarState();
}

class _AlMajlisNavigationBarState extends State<AlMajlisNavigationBar> {
  List<bool> isSelected = [false, false, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected[widget.selected] = true;
    print(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: Container(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                height: 70,
                decoration: BoxDecoration(
                  color: Constants.COLOR_DARK_GREY,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    bottomNavigationBtns("home", 0, "home-blue"),
                    bottomNavigationBtns("contact", 1, "contact-blue"),
                    bottomNavigationBtns(
                        "notification", 2, "notification-blue"),
                    bottomNavigationBtns(
                        "user-profile", 3, "user-profile-blue"),
                  ],
                ),
              ))),
    );
  }

  GestureDetector bottomNavigationBtns(
      String iconName, int index, String iconNameInBlue) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            if (index == widget.selected) {
              print("in same");
              widget.refreshFunction(new DateTime.now());
            }
            if (widget.selected == 3) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ActivityPosts()));
            } else if (widget.selected != 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ActivityPosts()));
            }
            if (index == widget.selected) {
              widget.refreshFunction(DateTime.now());
            }
            break;
          case 1:
            if (index == widget.selected) {
              print("in same");
              widget.refreshFunction();
            }
            if (widget.selected == 3) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ActivityDiscover()));
            } else if (widget.selected != 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ActivityDiscover()));
            }
            break;
          case 2:
            if (widget.selected == 3) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ActivityNotificaton()));
            } else if (widget.selected != 2) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ActivityNotificaton()));
            }
            if (index == widget.selected) {
              widget.refreshFunction();
            }
            break;
          case 3:
            if (widget.selected != 3)
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ActivityProfile()));
            if (index == widget.selected) {
              print("refresh");
              widget.refreshFunction();
            }
            break;
        }
        if (index != widget.selected) {}
      },
      child: Container(
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.selected == index
              ? Constants.COLOR_PRIMARY_TEAL_OPACITY
              : Constants.COLOR_DARK_GREY,
        ),
        child: Center(
          child: Image.asset(
            widget.selected == index
                ? "drawables/$iconNameInBlue.png"
                : "drawables/$iconName.png",
            height: 20,
          ),
        ),
      ),
    );
  }
}
