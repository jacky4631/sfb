/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 拼多多授权
 */
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/colors.dart';
import '../widget/loading.dart';

class PddAuthDialog extends Dialog {
  final Map data;
  PddAuthDialog(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8),
              SvgPicture.asset(
                   'assets/svg/arrow.svg',
                   width: 38,
                   height: 38,
                   colorFilter: ColorFilter.mode(Colours.app_main, BlendMode.srcIn)
               ),
              SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.asset(
                  'assets/images/mall/pdd.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '必须拼多多授权才可自动绑定订单',
            style: TextStyle(
               color: Colors.black.withValues(alpha: 0.75),
               fontSize: 15,
               fontWeight: FontWeight.bold,
             ),
          ),
          SizedBox(height: 8),
          Text(
            '请点击下方按钮进行拼多多授权',
            style: TextStyle(
               color: Colors.black.withValues(alpha: 0.75),
               fontSize: 13,
             ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          _createButton()
        ],
      ),
    );
  }

  _createButton() {
    return Builder(
      builder: (BuildContext context) {
    return TextButton(
        style: ButtonStyle(
             backgroundColor: WidgetStateProperty.all(
                 Color(0xFFFB040F)),
             shape: WidgetStateProperty.all(RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(25)),
             ))),
        onPressed: () async {

          Loading.show(context);
          Map res = await BService.pddAuth();
          String url = res['mobileUrl'];
          if(url.isNotEmpty) {
            LaunchApp.launchApp(url);
          }else {
            ToastUtils.showToast('授权失败');
          }
          if(data['callback']!=null) {
            data['callback']();
          }
          Loading.hide(context);

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
                      '前往拼多多授权',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]
          ),
        ));
      },
    );
  }

}
