import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  final List<String> days;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;

  const DropDownMenu({
    Key key,
    this.days,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
    this.onChange,
  })  : assert(days != null),
        super(key: key);
  @override
  _DropDownMenu createState() => _DropDownMenu();
}

class _DropDownMenu extends State<DropDownMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  BorderRadius _borderRadius;
  AnimationController _animationController;
  IconData iconDropDown = Icons.keyboard_arrow_down;
  String dropDownString;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
    setState(() {
      iconDropDown = Icons.keyboard_arrow_down;
    });
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50.0,
      key: _key,
      color: Colors.black,
      child: IconButton(
        icon: Row(
          children: <Widget>[
            Image.asset(
              "drawables/Mask Group 117.png",
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (dropDownString != null)
                  ? Text(
                      dropDownString,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    )
                  : Text(
                      "days",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
            ),
            Icon(
              iconDropDown,
              color: Constants.COLOR_DARK_TEAL,
              size: 20,
            )
          ],
        ),
        color: Colors.white,
        onPressed: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
          setState(() {
            iconDropDown = isMenuOpen
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down;
          });
        },
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF434343), //widget.backgroundColor,
                    borderRadius: _borderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.days.length,
                      (index) {
                        return GestureDetector(
                            onTap: () {
                              widget.onChange(index);
                              String s = widget.days[index];
                              String result = s.substring(0, s.indexOf('a'));
                              dropDownString = result;
                              closeMenu();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      widget.days[index],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  (index == widget.days.length - 1)
                                      ? Container()
                                      : Divider(
                                          height: 2,
                                          color: Colors.white,
                                        )
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}
