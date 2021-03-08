import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();


  Future<dynamic> navigateTo(var activityToNavigate) {
    print('\n\n');
    print(activityToNavigate.toString);
    print('here');
    print('\n\n');
    return navigatorKey.currentState.push(
        MaterialPageRoute(builder: (_) => activityToNavigate)
    );
  }

  goBack() {
    return navigatorKey.currentState.pop();
  }
}