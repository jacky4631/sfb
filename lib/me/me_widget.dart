/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/me/styles.dart';

import '../util/global.dart';
import '../widget/rise_number_text.dart';

createTodayFee(context, feeEmpty, userFee) {
  if(!Global.login) {
    return PWidget.textNormal('****',[Colors.white, 18,]);
  }
  return PWidget.row([
    Text('￥', style: TextStyles.meStyle),
    RiseNumberText(feeEmpty ? 0 : userFee!['minToday'],
        fixed: 2, style: TextStyles.meStyle),
    Text('-￥', style: TextStyles.meStyle),
    RiseNumberText(feeEmpty ? 0 : userFee!['maxToday'],
        fixed: 2, style: TextStyles.meStyle),
  ]);
}
createMonthFee(context, feeEmpty, userFee, {ts}) {
  if(!Global.login) {
    return PWidget.textNormal('****',[Colors.white, 18,]);
  }
  return PWidget.row([
    Text('￥', style: ts !=null ? ts:TextStyles.meStyle),
    RiseNumberText(feeEmpty ? 0 : userFee!['minMonth'],
        fixed: 2, style: ts !=null ? ts:TextStyles.meStyle),
    Text('-￥', style: ts !=null ? ts:TextStyles.meStyle),
    RiseNumberText(feeEmpty ? 0 : userFee!['maxMonth'],
        fixed: 2, style: ts !=null ? ts:TextStyles.meStyle),
  ]);
}