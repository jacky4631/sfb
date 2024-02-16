/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */

import 'package:flutter/widgets.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/login/login_shanyan.dart';
import 'package:sufenbao/util/global.dart';

import '../me/listener/PersonalNotifier.dart';

Future afterLogin(res, context, {close = 2}) async {
  if (res['success']) {
    var data = res['data'];
    String redirect = data['redirect'];
    //1代表需要跳转邀请码页面 0=不需要
    if(redirect == '1') {
      Navigator.pushNamed(context, '/loginCode', arguments: data);
    } else {
      loginThenRoutingMe(context, data, close: close);
    }
  } else {
    ToastUtils.showToast(res['msg']);
  }
}

loginThenRoutingMe(context, data, {close =2}) {
  Global.saveUser(data['token'], data['expires_time']);
  Global.initJPush();
  personalNotifier.value = true;
  //close 1=返回上一层 2=返回到index
  if(close == 1) {
    Navigator.pop(context);
  }else if(close == 2) {
    Navigator.of(context).popUntil((route) {
      return route.settings.name!.startsWith('/index');
    });
  }
}


onTapLogin(context, url, {args}) {
  if (!Global.login) {
    //闪验初始化成功，打开授权页， 初始化失败打开原登录页
    if(args == null) {
      args = {};
    }
    if(LoginShanyan.initSuc) {
      LoginShanyan.getInstance().openLoginAuthPlatformState();
      return;
    } else {

      url = '/login';
    }
  }
  Navigator.pushNamed(context, url, arguments: args);
}

onTapDialogLogin(BuildContext context, {fun, args}) async {
  if (!Global.login) {
    if(args == null) {
      args = {};
    }
    if(LoginShanyan.initSuc) {
      LoginShanyan.getInstance().openLoginAuthPlatformState();
      return;
    } else {

      Navigator.pushNamed(context, '/login', arguments: args);
    }
  } else {
    if(fun != null) {
      fun();
    }
  }
}

