import 'package:almajlis/utils/Constants.dart';
import 'package:almajlis/views/widgets/AlMajlisTextViewBold.dart';
import 'package:flutter/material.dart';

class AlMajlisCustomDropdown extends StatefulWidget {
  final List<String> days;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;
  String selectedValue;

  AlMajlisCustomDropdown({
    Key key,
    this.days,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
    this.selectedValue,
    this.onChange,
  })  : assert(days != null),
        super(key: key);
  @override
  _AlMajlisCustomDropdown createState() => _AlMajlisCustomDropdown();
}

class _AlMajlisCustomDropdown extends State<AlMajlisCustomDropdown>
    with SingleTickerProviderStateMixin {
  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  BorderRadius _borderRadius;
  AnimationController _animationController;
  IconData iconDropDown = Icons.keyboard_arrow_down;
  String selectedOption;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    if(null != widget.selectedValue && !widget.selectedValue.isEmpty) {
      selectedOption = widget.selectedValue;
      print("not null" + selectedOption);
    }
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
      width: double.infinity,
      height: 50.0,
      key: _key,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1.0,
            color: Constants.COLOR_PRIMARY_GREY
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(10.0) //         <--- border radius here
        ),
        color: Colors.transparent,
      ),
      child: IconButton(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: AlMajlisTextViewBold(
                null != selectedOption && !selectedOption.isEmpty ? "Occupation" : selectedOption,
                size: 16,
              ),
            ),
            Icon(
              iconDropDown,
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
                  width: double.infinity,
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
                              setState(() {
                                selectedOption = widget.days[index];
                              });
                              widget.onChange(index);
                              closeMenu();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      widget.days[index],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  index != widget.days.length - 1 ? Divider(
                                    height: 2,
                                    color: Colors.white,
                                  ) : Container()
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
