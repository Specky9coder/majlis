import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static final Color COLOR_PRIMARY_TEAL = Color(0xff0ED3B5);
  static final Color COLOR_PRIMARY_TEAL_OPACITY = Color(0x3C0ED3B5);
  static final Color COLOR_PRIMARY_TEAL_SHADOW = Color(0x0ED3B580);
  static final Color COLOR_DARK_TEAL = Color(0xff17E2C3);
  static final Color COLOR_PRIMARY_GREY = Color(0xff919191);
  static final Color COLOR_PRIMARY_TRANS_GREY = Color(0x3C919191);
  static final Color COLOR_TRANSFERANT_GREY = Color(0xff424242); //0xff616161
  static final Color COLOR_DARK_GREY = Color(0xff222222);
  static final Color COLOR_CARD_BLACK = Color(0Xf00000080);
  static final Color COLOR_30_WHITE = Color(0Xffffff4d);
  static final int SERVER_ERROR_NO_SUBSCRRIPTION = 3239051265;
  static final int SERVER_ERROR_LOGOUT = 2;
  static final int SERVER_ERROR_Unathorize = 401;
  static final int SERVER_ERROR_PACKAGE_LIMIT = 3239051266;

  static final String SUCCESS_URL = "/api/payment/success";
  static final String FAILURE_URL = "/api/payment/fail";

//  BUTTON Styles
  static final int OP_TEAL = 3;
  static final int TEAL = 1;
  static final int GREY = 2;
  static final int TRANS = 0;
  static final int TRANS_GREY = 4;

  static final List<String> reportReasons = [
    "Inappropriate Content",
    "Vulgar",
    "Pornography",
    "Abuse"
  ];
}
