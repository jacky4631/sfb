/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'global.dart';

const String TB = 'tb';
const String JD = 'jd';
const String PDD = 'pdd';
const String DY = 'dy';
const String VIP = 'vip';

double getHbTimes(String platform) {
  double? scale = 1;
  switch (platform) {
    case "tb":
      scale = Global.commissionInfo?.tbTimes;
      break;
    case 'jd':
      scale = Global.commissionInfo?.jdTimes;
      break;
    case 'pdd':
      scale = Global.commissionInfo?.pddTimes;
      break;
    case 'dy':
      scale = Global.commissionInfo?.dyTimes;
      break;
    case 'vip':
      scale = Global.commissionInfo?.vipTimes;
      break;
  }

  if(scale == null) {
    scale = 3;
  }
  return scale;
}


int? getLevel(String platform) {
  switch (platform) {
    case "tb":
      return Global.userinfo?.level;
    case 'jd':
      return Global.userinfo?.levelJd;
    case 'pdd':
      return Global.userinfo?.levelPdd;
    case 'dy':
      return Global.userinfo?.levelDy;
    case 'vip':
      return Global.userinfo?.levelVip;
  }
  return Global.userinfo?.level;
}