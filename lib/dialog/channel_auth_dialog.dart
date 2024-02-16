/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 渠道授权弹窗
 */
import 'package:flutter/material.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/colors.dart';
import 'package:sufenbao/util/toast_utils.dart';

import '../widget/loading.dart';

class ChannelAuthDialog extends Dialog {
  final Map data;
  ChannelAuthDialog(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      child: PWidget.column([
        PWidget.row([
          PWidget.image('assets/images/logo.png', [38, 38], {'crr': 19}),
          PWidget.boxw(8),
          SvgPicture.asset(
              'assets/svg/arrow.svg',
              width: 38,
              height: 38,
              color: Colours.app_main
          ),
          PWidget.boxw(8),
          PWidget.image('assets/images/mall/tb.png', [38, 38], {'crr': 19}),
        ], '221'),
        PWidget.boxh(8),
        PWidget.text('必须淘宝授权才可自动绑定订单',[Colors.black.withOpacity(0.75), 15, true]),
        PWidget.boxh(8),
        PWidget.text('请点击下方按钮进行淘宝授权',[Colors.black.withOpacity(0.75), 13],{'max':2}),
        PWidget.boxh(8),
        _createButton()
      ], '221'),
    );
  }

  _createButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color(0xFFFB040F)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ))),
        onPressed: () async {

            // FlutterAlibc.loginOut();

            FlutterAlibc.loginTaoBao(loginCallback: (LoginModel model) async{
              Loading.show(context);
              //todo 使用topAccessToken=sessionKey 后台调用taobao.tbk.sc.publisher.info.save，获取渠道
              //并绑定到用户/user/binding
              bool success = false;
              String failMsg = '授权失败';
              if(model.errorCode == '0') {
                print("登录淘宝  ${model.toString()} ");
                Map data = await BService.channelAuth(model.data?.topAccessToken);
                if(data['success']) {
                  ToastUtils.showToast('授权成功');
                  success = true;
                }else {
                  failMsg = data['msg'];
                }
              }
              if(!success) {
                ToastUtils.showToast(failMsg);
              }
              if(data['callback']!=null) {
               data['callback']();
              }
              Loading.hide(context);
            });

        },
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      '前往淘宝授权',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]
          ),
        ));
  }

}
