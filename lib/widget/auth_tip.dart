/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';

import '../service.dart';


abstract class AuthTip{
  ShakeAnimationController _shakeAnimationController = new ShakeAnimationController();
  Timer? timer;
  late bool showChannelWidget = false;

  Future isShowTip() async {
    Map data = await BService.tbAuthQuery();
    return !data['auth'];
  }

  Future initChannelId({callback}) async {
    bool showTip = await isShowTip();
    if(showTip){
      showChannelWidget = true;
      initShake();
      if(callback != null) {
        callback();
      }
    } else {
      showChannelWidget = false;
    }
  }

  Future initShake() async {
    timer = Timer.periodic(const Duration(seconds: 3), (t) {
      ///判断抖动动画是否正在执行
      if (_shakeAnimationController.animationRunging) {
        ///停止抖动动画
        _shakeAnimationController.stop();
      } else {
        ///开启抖动动画
        ///参数shakeCount 用来配置抖动次数
        ///通过 controller start 方法默认为 1
        _shakeAnimationController.start(shakeCount: 1);
      }
    });
  }

  void disposeTimer() {
    if(timer != null) {
      timer!.cancel();
    }
  }

  tipClick();

  Widget createChannelAuthWidget(img) {
    return PWidget.positioned(
        ShakeAnimationWidget(
          ///抖动控制器
          shakeAnimationController: _shakeAnimationController,
          ///微旋转的抖动
          shakeAnimationType: ShakeAnimationType.RoateShake,
          ///设置不开启抖动
          isForward: false,
          ///默认为 0 无限执行
          shakeCount: 0,
          ///抖动的幅度 取值范围为[0,1]
          shakeRange: 0.2,
          ///执行抖动动画的子Widget
          child: PWidget.container(PWidget.image('assets/images/mall/$img',[36,36],{'crr':18}),
              {'fun':() {
                tipClick();
              }}),
        ),
        [null, MediaQuery.of(context).padding.bottom+350, null , 2]
    );

  }

}
