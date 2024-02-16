/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

class Colours {
  static const Color bg_color = Color(0xfff1f1f1);
  static const Color dark_text_color = Colors.white;
  static const Color yellow_bg = app_main;
  static const Color energy_bg = Color(0xffF7F3DB);

  static const Color hb_bg = Color(0xFFFFECEC);
  static const Color share_bg = Color(0xffFAEDE0);

  static const Color material_bg = Color(0xFFFFFFFF);

  static const Color text = Color(0xFF333333);
  static const Color dark_text = Color(0xFFB8B8B8);
  
  static const Color text_gray = Color(0xFF999999);
  static const Color dark_text_gray = Color(0xFF666666);

  static const Color text_gray_c = Color(0xFFcccccc);
  static const Color dark_button_text = Color(0xFFF2F2F2);
  
  static const Color bg_gray = Color(0xFFF6F6F6);
  static const Color dark_bg_gray = Color(0xFF1F1F1F);

  static const Color line = Color(0xFFEEEEEE);
  static const Color dark_line = Color(0xFF3A3C3D);

  static const Color red = Color(0xFFFF4759);
  static const Color dark_red = Color(0xFFE03E4E);
  
  static const Color text_disabled = Color(0xFFD4E2FA);
  static const Color dark_text_disabled = Color(0xFFCEDBF2);

  static const Color button_disabled = Color(0xFF96BBFA);
  static const Color dark_button_disabled = Color(0xFF83A5E0);

  static const Color unselected_item_color = Color(0xffbfbfbf);
  static const Color dark_unselected_item_color = Color(0xFF4D4D4D);

  static const Color bg_gray_ = Color(0xFFFAFAFA);
  static const Color dark_bg_gray_ = Color(0xFF242526);

  static const Color gradient_blue = Color(0xFF5793FA);
  static const Color shadow_blue = Color(0x80A7C2F1);
  static const Color orange = Color(0xFFFF8547);

  static const Color app_main = Color(0xFFFC5434);
  // static const Color app_main = Color(0xFFFB040F);
  static const Color light_app_main = Color(0xFFFDEBEA);
  static const Color dark_app_main = Color(0xFFEF5B4D);

  static const Color jd_main = Colors.red;

  static const Color pdd_main = Color(0xFFED291E);

  static const Color dy_main = Color(0xFFFE2C55);

  static const Color vip_main = Color(0xFFFB008D);


  static const Color bg_light = Color(0xFFFFECEC);

  static const Color vip_light = Color(0xFFFDECC3);

  static const Color vip_dark = Color(0xFFF7CD7C);
  static const Color open_shop = Color(0xFF424140);

  static const Color vip_white = Colors.white;
  static const Color vip_black = Colors.black;
  static const Color nearlyDarkBlue = Colours.app_main;

  static getCollectColor(name, collect) {
    Color bgColor = Colors.black45;
    if(name == '收藏') {
      if(collect != null && collect) {
        bgColor = Colours.app_main;
      }
    }
    return bgColor;
  }
}
