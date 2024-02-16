/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

//定义会员卡片背景色
class VipData {
  final List<Color>? colors;
  const VipData({this.colors});
}
const Map<String, VipData> vipMap = {
  '1': const VipData(
    colors: [Color(0xFFE8C0A7), Color(0xFFB68567)]),
  '2': const VipData(
      colors: [Color(0xFFCDD6DF), Color(0xFF9FB5C7)]),
  '3': const VipData(
      colors: [Color(0xFFF3DA97), Color(0xFFB99C4C)]),
  '4': const VipData(
      colors: [Color(0xFFA1C2F7), Color(0xFF598BDA)]),
  '5': const VipData(
      colors: [Color(0xFFCBBEF4), Color(0xFF8A77C5)]),
};