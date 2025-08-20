/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/widget/custom_button.dart';

import '../../util/colors.dart';
import '../../util/login_util.dart';
import '../../util/toast_utils.dart';
import '../../index/Index.dart';

//账户注销
class AccountCancel extends StatefulWidget {
  final Map data;
  const AccountCancel(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _AccountCancelState createState() => _AccountCancelState();
}

class _AccountCancelState extends State<AccountCancel> {
  bool running = false;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('账户注销'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 20, 20),
            child: Column(
              children: [
                Center(
                    child: Icon(
                  Icons.remove_circle_outline,
                  size: 50,
                  color: Colors.red,
                )),
                SizedBox(height: 10),
                Text('您正在注销$APP_NAME账户', 
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
                SizedBox(height: 20),
                Text(
                  '一旦账户注销：',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text('\t1.您的账户信息将永久删除且无法恢复', 
                  style: TextStyle(color: Colors.red, fontSize: 14), 
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                Text('\t2.您账户所关联的订单将无法查询与找回', 
                  style: TextStyle(color: Colors.black, fontSize: 14), 
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    onTapLogin(
                      context,
                      '/cashIndex',
                    );
                  },
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: '\t3.您账户未结清的收入将被清空，',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '请注销前去提现',
                          style: TextStyle(color: Colors.red, fontSize: 14, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text('\t5.您授权的微信账户将会自动解绑', 
                  style: TextStyle(color: Colors.black, fontSize: 14), 
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                Text('\t6.您授权的支付宝账户将会自动解绑', 
                  style: TextStyle(color: Colors.black, fontSize: 14), 
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                Text('\t7.您的实名认证信息将会清空', 
                  style: TextStyle(color: Colors.black, fontSize: 14), 
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          btmBarView(context),
        ]));
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: SafeArea(
          child: Column(
        children: [
          CustomButton(
            bgColor: Colours.app_main,
            showIcon: false,
            textColor: Colors.white,
            text: '确认注销',
            onPressed: () {
              Global.showDialog2(
                  title: '温馨提示',
                  content: '您的账户信息将永久删除且无法恢复',
                  okPressed: () {
                    accountCancel();
                  });
            },
          )
        ],
      )),
    );
  }

  Future accountCancel() async {
    Map data = await BService.userDelete();
    if (data['success']) {
      ToastUtils.showToast('注销成功');
      final JPushFlutterInterface jpush = JPush.newJPush();
      await jpush.deleteAlias();
      Global.clearUser();
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => Index()), (Route router) => router == null);
    } else {
      ToastUtils.showToast('注销失败，请注销前去提现');
    }
  }
}
