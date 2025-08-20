/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

import 'package:sufenbao/me/styles.dart';

import '../util/global.dart';
import '../widget/rise_number_text.dart';

createTodayFee(context, userFee) {
  if (!Global.login) {
    return Text(
      '****',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
  return Row(
    children: [
      Text('￥', style: TextStyles.meStyle),
      RiseNumberText(ValueUtil.toNum(userFee['minToday']), fixed: 2, style: TextStyles.meStyle),
      Text('-￥', style: TextStyles.meStyle),
      RiseNumberText(ValueUtil.toNum(userFee['maxToday']), fixed: 2, style: TextStyles.meStyle),
    ],
  );
}

createMonthFee(context, userFee, {ts}) {
  if (!Global.login) {
    return Text(
      '****',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
  return Row(
    children: [
      Text('￥', style: ts != null ? ts : TextStyles.meStyle),
      RiseNumberText(ValueUtil.toNum(userFee['minMonth']), fixed: 2, style: ts != null ? ts : TextStyles.meStyle),
      Text('-￥', style: ts != null ? ts : TextStyles.meStyle),
      RiseNumberText(ValueUtil.toNum(userFee['maxMonth']), fixed: 2, style: ts != null ? ts : TextStyles.meStyle),
    ],
  );
}
