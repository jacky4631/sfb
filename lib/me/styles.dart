/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import '../util/colors.dart';
import 'colors.dart';
import '../util/dimens.dart';

class TextStyles {
  static TextStyle textStyle(
      {double fontSize= Dimens.font_sp12,
      Color color= Colors.white,
      FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: fontWeight,);
  }

  static TextStyle textBlack = textStyle(color: Colors.black);
  static TextStyle textWhite12 = textStyle(color: Colours.dark_text_color);
  static TextStyle textGrey12 = textStyle(color: Colors.grey);

  static TextStyle textWhite14 = textStyle(fontSize: Dimens.font_sp14, color: Colours.dark_text_color);

  static TextStyle textDark14 =
      textStyle(fontSize: Dimens.font_sp14, color: grey3Color);


  static TextStyle textWhite16 = textStyle(fontSize: Dimens.font_sp20);

  static TextStyle meStyle = ts(color: Colors.white, fontSize: 16, fontFamily: '');

  static TextStyle vipExpired = ts(fontWeight: FontWeight.normal, fontSize: 14);
  static TextStyle orderTitle =
      ts(color: Colours.vip_black, fontSize: 16, fontWeight: FontWeight.normal);
  static TextStyle loading =
      ts(color: Colours.app_main, fontSize: 16, fontWeight: FontWeight.normal);
  static TextStyle shareTitle = ts(color: Colors.black, fontSize: 16);
  static TextStyle shareContent =
      ts(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal);
  static TextStyle nowMoney = ts(color: Colors.white, fontSize: 32.0,
      fontWeight: FontWeight.bold, fontFamily: 'headlinea');
  static TextStyle nowMoneyBlack = ts(color: Colors.black, fontSize: 32.0,
      fontWeight: FontWeight.bold, fontFamily: 'headlinea');
  static TextStyle ts(
      {double fontSize= Dimens.font_sp14,
      Color color= Colors.white,
      FontWeight fontWeight= FontWeight.bold,
      TextDecoration decoration= TextDecoration.none,
      String fontFamily= 'headlinea'}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        fontFamily: fontFamily);
  }
}
