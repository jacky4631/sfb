/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:maixs_utils/widget/widget_tap.dart';
import 'package:sufenbao/me/cash/widgets/click_item.dart';

import '../../util/colors.dart';
import '../../util/global.dart';
import '../../service.dart';
import '../../util/paixs_fun.dart';
import '../../widget/rise_number_text.dart';
import '../listener/PersonalNotifier.dart';
import '../model/userinfo.dart';
import '../styles.dart';


class CashIndexPage extends StatefulWidget {
  final Map data;
  const CashIndexPage(this.data, {Key? key,}) : super(key: key);

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
    return ScaffoldWidget(
        brightness: Brightness.dark,
      appBar: buildTitle(context, title: '资金管理', widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PWidget.boxh(5),
            _buildCard(),
            PWidget.boxh(5),
            ClickItem(
              title: '提现',
              onTap: () {
                //只要进入提现界面 回来就刷新个人中心余额和本页面余额
                Navigator.pushNamed(context, '/cash', arguments: {'cash': nowMoney})
                    .then((value) {
                    personalNotifier.value = true;
                    initData();
                });
              },
            ),
            ClickItem(
              title: '提现记录',
              onTap: () => {
                Navigator.pushNamed(context, '/cashRecord')
              },
            ),
            ClickItem(
              title: '资金明细',
              onTap: () => {
                Navigator.pushNamed(context, '/moneyList')
              },
            ),
          ],
        ),
      )
    );
  }

  Widget _buildCard() {
    return PWidget.container(Column(
      children: <Widget>[
        _AccountMoney(
          title: '可提现余额(元)',
          money: '$nowMoney',
          alignment: MainAxisAlignment.end,
          moneyTextStyle: TextStyles.nowMoney,
          onTap: (){
            //只要进入提现界面 回来就刷新个人中心余额和本页面余额
            Navigator.pushNamed(context, '/cash', arguments: {'cash': nowMoney})
                .then((value) {
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
          onTap: (){
            //status=0 代表展示待解锁金额
            Navigator.pushNamed(context, '/moneyList', arguments: {'unlockStatus': 1});
          },
        ),

        Expanded(
          child: Row(
            children: <Widget>[
              _AccountMoney(title: '累计结算金额',
                  money: json['totalExtract'].toString()),
              // _AccountMoney(title: '累计发放佣金', money: '0.02'),
            ],
          ),
        ),
      ],
    ),[null, 250],
        {
          // 'bd': PFun.bdAllLg(Colors.white),
          'pd':8,
          'mg':8,
          'br': PFun.lg(16, 16, 16, 16),
          'gd': PFun.tl2brGd(Colours.app_main, Colours.app_main.withOpacity(0.7)),

        });
  }
}

class _AccountMoney extends StatelessWidget {

  const _AccountMoney({
    required this.title,
    required this.money,
    this.alignment,
    this.moneyTextStyle,
    this.onTap
  });

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
            PWidget.boxh(8),
            WidgetTap(child: RiseNumberText(
                NumUtil.getDoubleByValueStr(money) ?? 0,
                style: moneyTextStyle ?? const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'headlinea'
                )
            ),onTap: this.onTap,),
          ],
        ),
      ),
    );
  }
}