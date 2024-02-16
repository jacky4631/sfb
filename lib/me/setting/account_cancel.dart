/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
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
  const AccountCancel(this.data, {Key? key,}) : super(key: key);

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
    return ScaffoldWidget(
        body: Stack(children: [
      ScaffoldWidget(
          brightness: Brightness.dark,
          bgColor: Colors.white,
          appBar: buildTitle(context,
              title: '账户注销',
              widgetColor: Colors.black,
              leftIcon: Icon(Icons.arrow_back)),
          body: PWidget.container(
              PWidget.column([
                Center(child:Icon(Icons.remove_circle_outline, size: 50,color: Colors.red,)),
                PWidget.boxh(10),
                PWidget.text('您正在注销$APP_NAME账户', [Colors.black, 20, true],{'ct':true}),
                PWidget.boxh(20),
                PWidget.text(
                  '一旦账户注销：',
                  [Colors.red, 18, true],
                ),
                PWidget.boxh(15),
                PWidget.text('\t1.您的账户信息将永久删除且无法恢复', [Colors.red, 14],
                    {'max': 2}),
                PWidget.boxh(5),
                PWidget.text('\t2.您账户所关联的订单将无法查询与找回', [Colors.black, 14],
                    {'max': 2}),
                PWidget.boxh(5),
                PWidget.text('\t3.您账户未结清的收入将被清空，',
                    [Colors.black, 14], {'max': 2,'fun':(){
                      onTapLogin(context, '/cashIndex',);
                    }},[
                      PWidget.textIs('请注销前去提现', [Colors.red, 14],  {'td': TextDecoration.underline}),
                    ]),
                PWidget.boxh(5),
                PWidget.text('\t5.您授权的微信账户将会自动解绑', [Colors.black, 14], {'max': 2}),
                PWidget.boxh(5),
                PWidget.text('\t6.您授权的支付宝账户将会自动解绑', [Colors.black, 14], {'max': 2}),
                PWidget.boxh(5),
                PWidget.text('\t7.您的实名认证信息将会清空', [Colors.black, 14], {'max': 2}),
              ]),
              {
                'pd': [5, 5, 20, 20]
              })),
      btmBarView(context),
    ]));
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return PWidget.positioned(
      SafeArea(
          child: Column(
        children: [
          CustomButton(
            bgColor: Colours.app_main,
            showIcon: false,
            textColor: Colors.white,
            text: '确认注销',
            onPressed: () {
              Global.showDialog2(title: '温馨提示', content: '您的账户信息将永久删除且无法恢复', okPressed: (){
                accountCancel();
              });
            },
          )
        ],
      )),
      [null, 10, 20, 20],
    );
  }

  Future accountCancel() async{

    Map data = await BService.userDelete();
    if(data['success']) {
      ToastUtils.showToast('注销成功');
      JPush jpush = new JPush();
      await jpush.deleteAlias();
      Global.clearUser();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Index()),
              (Route router) => router == null);
    } else {
      ToastUtils.showToast('注销失败，请注销前去提现');
    }

  }
}
