/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:sufenbao/me/cash/widgets/click_item.dart';

import '../../dialog/extract_rule_dialog.dart';
import '../../util/colors.dart';
import '../../util/global.dart';
import '../../service.dart';

import '../../widget/rise_number_text.dart';
import '../listener/PersonalNotifier.dart';
import '../model/userinfo.dart';
import '../styles.dart';

class CashIndexPage extends StatefulWidget {
  final Map data;
  const CashIndexPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _CashIndexPageState createState() => _CashIndexPageState();
}

class _CashIndexPageState extends State<CashIndexPage> {
  late Map<String, dynamic> json = {};
  double nowMoney = 0.0;
  double unlockMoney = 0.0;
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///初始化函数
  Future initData() async {
    json = await BService.userinfo();
    Userinfo userinfo = Userinfo.fromJson(json);
    Global.userinfo = userinfo;
    setState(() {
      nowMoney = userinfo.nowMoney;
      unlockMoney = userinfo.unlockMoney;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('资金管理', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: '',
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder:
                        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return Scaffold(backgroundColor: Colors.transparent, body: ExtractRuleDialog({}, () {}));
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text('提现规则', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              _buildCard(),
              SizedBox(height: 5),
              ClickItem(
                title: '提现',
                onTap: () {
                  //只要进入提现界面 回来就刷新个人中心余额和本页面余额
                  Navigator.pushNamed(context, '/cash', arguments: {'cash': nowMoney}).then((value) {
                    personalNotifier.value = true;
                    initData();
                  });
                },
              ),
              ClickItem(
                title: '提现记录',
                onTap: () => {Navigator.pushNamed(context, '/cashRecord')},
              ),
              ClickItem(
                title: '资金明细',
                onTap: () => {Navigator.pushNamed(context, '/moneyList')},
              ),
            ],
          ),
        ));
  }

  Widget _buildCard() {
    return Container(
      height: 250,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.app_main, Colours.app_main.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        children: <Widget>[
          _AccountMoney(
            title: '可提现余额(元)',
            money: '$nowMoney',
            alignment: MainAxisAlignment.end,
            moneyTextStyle: TextStyles.nowMoney,
            onTap: () {
              //只要进入提现界面 回来就刷新个人中心余额和本页面余额
              Navigator.pushNamed(context, '/cash', arguments: {'cash': nowMoney}).then((value) {
                personalNotifier.value = true;
                initData();
              });
            },
          ),
          _AccountMoney(
            title: '待解锁余额(元)',
            money: '$unlockMoney',
            alignment: MainAxisAlignment.end,
            moneyTextStyle: TextStyles.nowMoney,
            onTap: () {
              //status=0 代表展示待解锁金额
              Navigator.pushNamed(context, '/moneyList', arguments: {'unlockStatus': 1});
            },
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                _AccountMoney(title: '累计结算金额', money: json['totalExtract'].toString()),
                // _AccountMoney(title: '累计发放佣金', money: '0.02'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMoney extends StatelessWidget {
  const _AccountMoney({required this.title, required this.money, this.alignment, this.moneyTextStyle, this.onTap});

  final String title;
  final String money;
  final MainAxisAlignment? alignment;
  final TextStyle? moneyTextStyle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          mainAxisAlignment: alignment ?? MainAxisAlignment.center,
          children: <Widget>[
            /// 横向撑开Column，扩大语义区域
            const SizedBox(width: double.infinity),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: this.onTap,
              child: RiseNumberText(NumUtil.getDoubleByValueStr(money) ?? 0,
                  style: moneyTextStyle ??
                      const TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'headlinea')),
            ),
          ],
        ),
      ),
    );
  }
}
