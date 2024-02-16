/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import '../../util/global.dart';

class CommissionInfo {
  int tbRebateScale = TB_SCALE;
  int hbRebateScale = BASE_SCALE;
  int jdHbRebateScale = BASE_SCALE;
  int pddHbRebateScale = BASE_SCALE;
  int dyHbRebateScale = BASE_SCALE;
  int vipHbRebateScale = BASE_SCALE;
  double hbMinTimes = 0.5;
  double hbMaxTimes = 10;
  double tbTimes = TIMES;
  double jdTimes = TIMES;
  double pddTimes = TIMES;
  double dyTimes = TIMES;
  double vipTimes = TIMES;

  CommissionInfo();

  CommissionInfo.fromJson(Map<String, dynamic> json)
      : tbRebateScale = json['tbRebateScale']??TB_SCALE,
        hbRebateScale = json['hbRebateScale']??BASE_SCALE,
        jdHbRebateScale = json['jdHbRebateScale']??BASE_SCALE,
        pddHbRebateScale = json['pddHbRebateScale']??BASE_SCALE,
        dyHbRebateScale = json['dyHbRebateScale']??BASE_SCALE,
        vipHbRebateScale = json['vipHbRebateScale']??BASE_SCALE,
        hbMinTimes = json['hbMinTimes']??0.5,
        hbMaxTimes = json['hbMaxTimes']??10,
        tbTimes = json['tbTimes']??TIMES,
        jdTimes = json['jdTimes']??TIMES,
        pddTimes = json['pddTimes']??TIMES,
        dyTimes = json['dyTimes']??TIMES,
        vipTimes = json['vipTimes']??TIMES;

  Map<String, dynamic> toJson() => {
        'tbRebateScale': tbRebateScale,
        'hbRebateScale': hbRebateScale,
    'jdHbRebateScale': jdHbRebateScale,
    'pddHbRebateScale': pddHbRebateScale,
    'dyHbRebateScale': dyHbRebateScale,
    'vipHbRebateScale': vipHbRebateScale,
        'hbMinTimes': hbMinTimes,
        'hbMaxTimes': hbMaxTimes,
    'tbTimes': tbTimes,
    'jdTimes': jdTimes,
    'pddTimes': pddTimes,
    'dyTimes': dyTimes,
    'vipTimes': vipTimes
      };
}
