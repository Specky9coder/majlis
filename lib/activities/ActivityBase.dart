import 'package:almajlis/core/core.dart';
import 'package:almajlis/services/PushRegisterService.dart';
import 'package:flutter/material.dart';

abstract class ActivityStateBase<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _buildComplete = false;
  bool _coreInitialized = false;
  Core core;
  final PushRegisterService _pushRegisterService = PushRegisterService();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        _pushRegisterService.isForeground = true;
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        _pushRegisterService.isForeground = false;
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        _pushRegisterService.isForeground = false;
        break;
      case AppLifecycleState.detached:
        _pushRegisterService.isForeground = false;
        print("app in detached");
        break;
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ActivityStateBase() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildComplete = true;
      print("=== build initialized");
      if (_coreInitialized) {
        onWidgetInitialized();

        core.updateFCMToken();
      }
    });

    core = Core(onInitComplete: () {
      _coreInitialized = true;
      print("=== core initialized");
      if (_buildComplete) {
        onWidgetInitialized();
      }
    });

    if (core.isInitialized) {
      _coreInitialized = true;
    }
  }

  // Call function when the initialization is complete
  onWidgetInitialized();
}
