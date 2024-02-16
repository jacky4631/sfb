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

Map getHbData(commission, platform) {
  if(Global.isEmpty(platform)) {
    platform = 'tb';
  }

  Map dynamicCommission = Global.getDynamicCommission(commission);

  String min = dynamicCommission['min'];
  String max = dynamicCommission['max'];
  return {'min':min, 'max':max};
}