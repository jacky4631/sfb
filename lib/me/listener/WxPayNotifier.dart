/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart';

//微信支付通知
class WxPayNotifier extends ValueNotifier<BaseWeChatResponse> {
  WxPayNotifier(value) : super(value);
}

WxPayNotifier wxPayNotifier = new WxPayNotifier(BaseWeChatResponse.create('onShareResponse',
    {'type':1}));
