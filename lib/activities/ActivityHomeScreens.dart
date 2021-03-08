import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/material.dart';

import 'ActivityDiscover.dart';
import 'ActivityNotification.dart';
import 'ActivityPosts.dart';
import 'ActivityProfile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ActivityPosts(),
    ActivityDiscover(),
    ActivityNotificaton(),
    ActivityProfile()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        backgroundColor: Colors.transparent,
        body: _children[_currentIndex],
    
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    floatingActionButton: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        alignment: Alignment.center,
        height: 70,
        decoration: BoxDecoration(
          color: Constants.COLOR_DARK_GREY,
          borderRadius: BorderRadius.circular(22),
          
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Constants.COLOR_DARK_GREY,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: new Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _currentIndex == 0
                                ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                                : Constants.COLOR_DARK_GREY,
                          ),
                        child: Center(
                          child:Image.asset(
                        _currentIndex == 0
                            ? 'drawables/home-blue.png'
                            : 'drawables/home.png',
                        height: 20,
                      ),
                    )
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  
                  icon: new Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _currentIndex == 1
                                ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                                : Constants.COLOR_DARK_GREY,
                          ),
                        child: Center(
                          child: new Image.asset(
                        _currentIndex == 1
                            ? 'drawables/contact-blue.png'
                            : 'drawables/contact.png',
                        height: 20,
                      ),
                    )
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  
                  icon: new Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _currentIndex == 2
                                ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                                : Constants.COLOR_DARK_GREY,
                          ),
                        child: Center(
                          child: new Image.asset(
                            _currentIndex == 2
                                ? 'drawables/notification-blue.png'
                                : 'drawables/notification.png',
                            height: 20,
                          ),
                    )
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  
                  icon: new Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _currentIndex == 3
                                ? Constants.COLOR_PRIMARY_TEAL_OPACITY
                                : Constants.COLOR_DARK_GREY,
                          ),
                        child: Center(
                          child: new Image.asset(
                    _currentIndex == 3
                        ? 'drawables/user-profile-blue.png'
                        : 'drawables/user-profile.png',
                    height: 20,
                  ),
                    )
                  ),
                  label: '')
            ],
          ),)
        )));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
