import 'package:flutter/material.dart';

class AlMajlisBackground extends StatefulWidget {
  Widget child;
  AppBar appBar;
  var onPop;
  bool hasBottomNaviagation;
  int bottomNavigationScreenType;
  var refreshFunction;
  AlMajlisBackground(this.child,
      {this.appBar,
      this.onPop,
      this.hasBottomNaviagation = false,
      this.bottomNavigationScreenType = 0,
      this.refreshFunction});

  @override
  _AlMajlisBackgroundState createState() => _AlMajlisBackgroundState();
}

class _AlMajlisBackgroundState extends State<AlMajlisBackground> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBar,
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Container(
            color: Colors.black,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                widget.child,
                // Visibility(
                //   visible: widget.hasBottomNaviagation,
                //   child: Container(
                //     height: double.infinity,
                //     width: double.infinity,
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: <Widget>[
                //         AlMajlisNavigationBar(widget.bottomNavigationScreenType, widget.refreshFunction)
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (null != widget.onPop) {
      widget.onPop();
    }
    Navigator.pop(context);
    return false;
  }
}
