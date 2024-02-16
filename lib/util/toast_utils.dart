/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

class ToastUtils{
  static void showToast(String msg,{bgColor = Colours.app_main}) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: bgColor,
        gravity: ToastGravity.CENTER,
        webPosition: 'center',
        webBgColor: "linear-gradient(to right, #FF425D, #FF425D)");
  }
  static void showToastBOTTOM(String msg,{bgColor = Colours.app_main}) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: bgColor,
        gravity: ToastGravity.BOTTOM,
        webPosition: 'center',
        webBgColor: "linear-gradient(to right, #FF425D, #FF425D)");
  }
}